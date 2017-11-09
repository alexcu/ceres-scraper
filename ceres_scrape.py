#!/usr/bin/env python3

import os
import json
import sys
import numpy as np
from scipy import interpolate

NUM_PERCENTILES = 10
BASELINE_START_SENTIMENT = 50.0


def avg_sentiment(sentiment_data, t0, t1):
    slices = [sentiment for time, sentiment in sentiment_data.items()
              if time >= t0 and time <= t1]
    if len(slices) > 0:
        return np.average(slices)
    else:
        return None


def process_call(call_id, call_data):
    if call_data["topics"] is None or call_data["sentiment"] is None:
        return None

    sentiment = dict(zip(call_data["sentiment"]["time"],
                         call_data["sentiment"]["sentiment"]))
    normalized_sentiment = []

    t0 = 0
    step = int(100 / NUM_PERCENTILES)

    for t1 in range(step, 100 + step, step):
        avg = avg_sentiment(sentiment, t0, t1)
        if avg is None and t0 == 0:
            avg = BASELINE_START_SENTIMENT
        normalized_sentiment.append(avg)
        t0 = t1

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
        interpolated_sentiment["sentiment_t{}".format(
            actual_t)] = str(sentiment)

    topic_prominence = list(call_data["topics"].keys())[0]
    date = call_data["stats"]["date"]
    time = call_data["stats"]["time"]
    static = {
        "id": call_id,
        "timestamp": "{} {}".format(date, time),
        "queue": call_data["stats"]["queue"],
        "agent": call_data["stats"]["agent"],
        "duration": str(call_data["stats"]["duration"]),
        "num_tokens": str(call_data["stats"]["num_tokens"]),
        "most_prominent_topic_id": topic_prominence[0]
    }

    return {**static, **interpolated_sentiment}


def csvify(raw_data):
    print_headers = True
    for call_id, call_data in raw_data.items():
        data_for_call = process_call(call_id, call_data)
        if data_for_call is None:
            continue
        if print_headers is True:
            print_headers = False
            print(",".join(data_for_call.keys()))
        print(",".join(data_for_call.values()))


def main():
    assert len(sys.argv) - 1 >= 1, "Must provide JSON input file"

    in_file = sys.argv[1]
    assert in_file != None, "Missing JSON input"

    with open(in_file, 'r') as fptr:
        raw_data = json.load(fptr)

    csvify(raw_data)


if __name__ == '__main__':
    main()
