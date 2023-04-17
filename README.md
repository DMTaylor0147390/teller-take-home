# TellerTakeHome

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## How To Make Requests Against the Running Server

In this README, we'll cover making cURL requests against this project when it's running.

The instructions for how to run this server are in the above section.

To enroll a given user, run the following cURL request:

```curl -X POST localhost:4000/enroll -d '{"username": <username>, "password": <password>, "device_type": <"SMS" or "VOICE">' -H 'accept: application/json' -H 'content-type: application/json'```

To list the accounts for a given user, run the following cURL request:

```curl localhost:4000/accounts -H 'Authorization: Basic <Base64 encoding of "username:password">```

To list the transactions for a given user's account, run the following cURL request:

```curl localhost:4000/<account ID>/transactions -H 'Authorization: Basic <Base64 encoding of "username:password">```

For the sake of convenience, there is a Postman export in this project that can be imported to Postman to experiment with these requests, in case cURL requests prove unwieldy.

## My Approach

For this problem, my approaach was to try and build small, composable functions that can be easily read, understood and extended. I would then use these functions to build the top-level functions that the endpoints would call for the requests.

At the lowest level, we have functions that take in a request path and returns the URL and headers needed to successfully perform the request. The functions for the headers are especially important, since one of the important needs for this project is taking the header data returned from a successful request and using it to generate the headers needed for the next request.

With these low-level functions, I was able to write functions such as `signin`, `signin_mfa`, and `get_account_transactions`, all of which simply take in the data for the request and some headers and generate the URL and headers for the request before performing it.

These functions are then used to build the three functions that are used for the three endpoints that the project asks for (`enroll`, `list_accounts`, `list_transactions`). All of these functions live in `TellerTakeHome.Requests`. Beyond this, there is some error handling in `TellerTakeHomeWeb.PageController` so that, if an unexpected error occurs in the process of responding to a request, the human-readable part of the error can bubble up to the user.

As for the re-authentication, my solution was to take the `a_token` that is included in the successful signin response and write it to disk. More specifically, I associate the Base64 encoding of the username and an encoding of the password to the token. If the user passes in the Base64 encoding of their username and password as a Basic Auth header, then the server will then transform the header into the key for the token. If the token exists for that key, then the server will try to sign in with that token. If it does so successfully, then it will proceed with responding to the request. Otherwise, the server will tell the client to re-enroll in order to continue. I used a normal text file just for the sake of ease. In real life, this data would likely live in a Redis server.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
