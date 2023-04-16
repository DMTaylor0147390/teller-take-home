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

```curl -X POST localhost:4000/enroll -d '{"username": <username>, "password": <password>, "device_type": <"SMS" or "VOICE">}'
                                      -H 'accept: application/json'
                                      -H 'content-type: application/json'```

To list the accounts for a given user, run the following cURL request:

```curl localhost:4000/accounts -H 'Authorization: Basic <Base64 encoding of "username:password">```

To list the transactions for a given user's account, run the following cURL request:

```curl localhost:4000/<account ID>/transactions -H 'Authorization: Basic <Base64 encoding of "username:password">```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
