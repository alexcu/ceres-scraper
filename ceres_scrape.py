#!/usr/bin/env python3

import os
import json
import sys
import numpy as np
from scipy import interpolate

NUM_PERCENTILES = 10
BASELINE_START_SENTIMENT = 50.0
BASELINE_END_SENTIMENT = 75.0


def avg_sentiment(sentiment_data, t0, t1):
    slices = [sentiment for time, sentiment in sentiment_data.items()
              if time >= t0 and time <= t1]
    if len(slices) > 0:
        return np.average(slices)
    else:
        return None


def process_sentiment(call_data, sentiment_type):
    assert sentiment_type in ["mono", "agent", "client"]
    sentiment = dict(zip(call_data["sentiment"][sentiment_type]["time"],
                         call_data["sentiment"][sentiment_type]["sentiment"]))
    normalized_sentiment = []

    t0 = 0
    step = int(100 / NUM_PERCENTILES)

    for t1 in range(step, 100 + step, step):
        avg = avg_sentiment(sentiment, t0, t1)
        if avg is None and t0 == 0:
            avg = BASELINE_START_SENTIMENT
        normalized_sentiment.append(avg)
        t0 = t1

    # Set baseline end sentiment if no sentiment was found on final t
    last_sentiment = len(normalized_sentiment) - 1
    if normalized_sentiment[last_sentiment] is None:
        normalized_sentiment[last_sentiment] = BASELINE_END_SENTIMENT

    # Go through averages, find any none and use spline interpolation
    # to find the new value
    interpolated_sentiment = {}
    x_vals = [t for t, s in enumerate(normalized_sentiment) if s is not None]
    y_vals = [s for s in normalized_sentiment if s is not None]
    tck = interpolate.splrep(x_vals, y_vals, s=0, k=1)
    for t, sentiment in enumerate(normalized_sentiment):
        if sentiment is None:
            sentiment = interpolate.splev(t, tck, der=0)
        actual_t = (t + 1) * 10
        key = "{}_sentiment_t{}".format(sentiment_type, actual_t)
        interpolated_sentiment[key] = sentiment

    return interpolated_sentiment

def process_call(call_id, call_data, call_center_id):
    if call_data["topics"] is None or call_data["sentiment"] is None:
        return None

    mono_sentiment = process_sentiment(call_data, "mono")

    has_dual_track_sentiment = ("agent" in call_data["sentiment"] and
                                "client" in call_data["sentiment"])

    agent_sentiment = {}
    client_sentiment = {}
    if has_dual_track_sentiment:
        agent_sentiment = process_sentiment(call_data, "agent")
        client_sentiment = process_sentiment(call_data, "client")

    topic_prominence = list(call_data["topics"].keys())[0]
    date = call_data["stats"]["date"]
    time = call_data["stats"]["time"]
    static = {
        "id": call_id,
        "timestamp": "{} {}".format(date, time),
        "queue": call_data["stats"]["queue"],
        "agent": call_data["stats"]["agent"],
        "duration": call_data["stats"]["duration"],
        "num_tokens": call_data["stats"]["num_tokens"],
        "most_prominent_topic_id": topic_prominence[0],
        "call_center_id": call_center_id,
        "has_dual_track_sentiment": has_dual_track_sentiment
    }

    return {**static, **mono_sentiment, **agent_sentiment, **client_sentiment}


def csvify(raw_data, call_center_id, print_headers):
    for call_id, call_data in raw_data.items():
        data_for_call = process_call(call_id, call_data, call_center_id)
        if data_for_call is None:
            continue
        if print_headers is True:
            print_headers = False
            print(",".join(data_for_call.keys()))
        print(",".join([str(v) for v in data_for_call.values()]))


def main():
    assert len(sys.argv) - 1 >= 2, "Must provide JSON input file and call centre ID"

    in_file = sys.argv[1]
    assert in_file != None, "Missing JSON input"

    call_center_id = sys.argv[2]
    assert call_center_id != None, "Missing Call Centre ID"

    print_headers = bool(sys.argv[3]) if len(sys.argv) - 1 >= 3 else False

    with open(in_file, 'r') as fptr:
        raw_data = json.load(fptr)

    csvify(raw_data, call_center_id, print_headers)


if __name__ == '__main__':
    main()
