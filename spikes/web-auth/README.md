# Spring Boot - Reference OAuth2 Authorisation/Resource Server

This is a reference project for an OAuth2 Authorisation Server + Resource Server built with Spring Boot.

## Features

In OAuth2 applications, it is up to you whether the Authorisation Server and Resource Server reside on the same server or on different ones. For demonstration purposes, this app implements the former.

In a microservices architecture, it might be desirable to have many Resource Servers share a single Authorisation Server.

Noteworthy files to peruse:

* `src/main/java/config/AuthorizationServerConfig.java`: Configures the app to act as an Authorisation Server (role that provides access tokens)
* `src/main/java/config/AuthorizationServerSecurityConfig.java`: Configures how the Authorisation Server integrates with Spring Security (how users/roles are described, which endpoints are accessible, etc.)
* `src/main/java/config/ResourceServerConfig`: Configures the app to act as a Resource Server (role that serves the actual data that is protected by OAuth). This server has two endpoints: `/` and `/private`.

## Setup

### Database

1. Create an empty PostgreSQL database named `spring_beaut_auth`. The database will be populated automatically with Flyway migrations the first time you run the Spring Boot app.

## Build

### IntelliJ IDEA

1. Generate an IntelliJ project with `.gradlew idea`.
2. Import the project into IntelliJ and build from within the IDE.

### Command line

1. Run `./gradlew build` from the project root.

## Run

After building, either use IntelliJ to run, or run `java -jar build/libs/spring-boot-reference-app-0.0.1-SNAPSHOT.jar`.

## Test

This example app provides authentication details for a sample OAuth2 Client Application as well as a sample Resource Owner (user).

It is recommended that you install [Postman](https://www.getpostman.com/) prior to following the steps below.

### 1. Test the provided endpoints

1. Perform a `GET` request to http://localhost:8080/. You should get the following response:

```
{
    "response": "Welcome to the public area. No authentication required!"
}
```

1. Perform a GET request to http://localhost:8080/private. You should get the following error message this time, because you have not supplied an access token:

```
{
    "error": "unauthorized",
    "error_description": "Full authentication is required to access this resource"
}
```

### 2. Use the Client details to obtain an OAuth2 token using `password` grant type

1. Perform a `POST` request to http://localhost:8080/oauth/token with the following details:

* Authentication: Basic Auth
* Username: `my-trusted-client-id`
* Password: `my-trusted-client-secret`
* `x-www-form-urlencoded` Body:
    - `grant_type`: `password`
    - `username`: `admin`
    - `password`: `password`

**NOTE:** Never provide the `grant_type`, `username`, and `password` through query parameters. Though query parameters are secure during transmission they are stored as plain-text in browser history, HTTP referrer headers, and server request logs.
  

You should receive a response like the following:


```
{
    "access_token": "6fb01452-1a94-4907-b013-a013ca2ea36a",
    "token_type": "bearer",
    "refresh_token": "be944bc2-5769-472d-bb5b-a76526d4e36d",
    "expires_in": 35999,
    "scope": "read write"
}
```

1. Copy down the value of `access_token`; you will need it in the next step.

### 3. Supply the OAuth2 token to the /private endpoint

1. Perform a `GET` request to http://localhost:8080/private again, this time with the following details in the HTTP headers:

* `Authorization`: `Bearer 6fb01452-1a94-4907-b013-a013ca2ea36a` (the token you copied from the previous step)

Because you supplied a valid token, you should now receive the following response:

```
{
    "response": "Welcome to the private area, you VIP you."
}
```

### 4. Use a browser to test the `authorization_code` / `implicit` grant types

1. Point your browser to http://localhost:8080/private. You should be presented with a login page.
1. Enter `admin` for the username and `password` for the password.
1. You should be redirected to the `/private` endpoint, which displays the same message as in the previous step. The auth details should be saved in a session cookie, which will allow you to close and reopen the browser without having to re-enter user details.

**Note: Currently having some issues with this workflow due to conflicting Spring Security filters. This will be fixed ASAP.**

## Deploy

This repository is deployable to AWS using [Maestro Deployment Orchestrator](https://github.com/dstil/maestro). This is still under development, however, so check back on this aspect soon.

## Useful links

- [Introduction to OAuth2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)
- [Guide to OAuth2 grant types](https://alexbilbie.com/guide-to-oauth-2-grants/)
- [Spring Security OAuth2 docs](https://projects.spring.io/spring-security-oauth/docs/oauth2.html)
- [Deciding on an Access Token's Lifetime](https://www.oauth.com/oauth2-servers/access-tokens/access-token-lifetime/)
