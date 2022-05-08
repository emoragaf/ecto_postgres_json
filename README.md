# EctoPostgresJson
Ecto utilities to work with Postgresql JSON-b columns

## Indexes

Provides a `json_index` function to use alongside Ecto migrations that handles the creation of key and column GIN based indexes for JSONb columns

## Installation

The package can be installed
by adding `ecto_postgres_json` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_postgres_json, "~> 0.1.0"}
  ]
end
```

The docs can
be found at <https://hexdocs.pm/ecto_postgres_json>.

## Usage

Import the utility module in your migration

```elixir
defmodule MyApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration
  import EctoPostgresJson.Index
...
end
```

Define indexes using `EctoPostgresJson.Index.json_index/3`

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
    create json_index(:posts, ["payload", "tags"])
  end
end
```
