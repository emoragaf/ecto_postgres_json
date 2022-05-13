# EctoPostgresJson

[![Hex Version](https://img.shields.io/hexpm/v/ecto_postgres_json.svg)](https://hex.pm/packages/ecto_postgres_json)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_postgres_json/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_postgres_json.svg)](https://hex.pm/packages/ecto_postgres_json)
[![License](https://img.shields.io/hexpm/l/ecto_postgres_json.svg)](https://github.com/emoragaf/ecto_postgres_json/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/emoragaf/ecto_postgres_json.svg)](https://github.com/emoragaf/ecto_postgres_json/commits/master)

`Ecto` utilities to work with PostgreSQL
[JSONb](https://www.postgresql.org/docs/current/datatype-json.html) columns.

## Indexes

Provides a `json_index/3` function to use alongside Ecto migrations that handles
the creation of key and column GIN based indexes for JSONb columns.

## Installation

The package can be installed by adding `:ecto_postgres_json` to `deps/0`
function in `mix.exs`:

```elixir
{:ecto_postgres_json, "~> 0.1.0"},
```

## Usage

Import the utility module in your migration:

```elixir
defmodule MyApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration
  import EctoPostgresJson.Index
...
end
```

Define indexes using `EctoPostgresJson.Index.json_index/3`:

```elixir
defmodule MyApp.Repo.Migrations.CreatePosts do
  ...
  def change do
    create table(:posts) do
      add :name, :string
      add :payload, :map

      timestamps()
    end
    create json_index(:posts, :payload)
    create json_index(:posts, ["payload", "tags"], name: :post_tags_index)
  end
end
```

## Copyright and License

Copyright (c) 2022 Eduardo Moraga

This work is free. You can redistribute it and/or modify it under the terms of
the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
