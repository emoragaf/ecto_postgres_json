defmodule EctoPostgresJson.Index do
  @moduledoc """
  Provides a json_index/3 function to pass to Ecto migration to handle the creation of JSONb Indexes
  """

  alias Ecto.Migration.Index

  @doc ~S"""
  Returns an index struct that can be given to Ecto.Migration `create/1`, `drop/1`, etc.
  Expects the table name as the first argument and the field(s) as
  the second. The fields can be atoms, representing the JSONb column name, or a list of strings,
  representing the JSONb colum name + JSON attributes to index.
  ## Options
    * `:name` - the name of the index. Defaults to "#{"idxgin" | "idxginp"}#{table}_#{fields}".
    * `:unique` - indicates whether the index should be unique. Defaults to
      `false`.
    * `:concurrently` - indicates whether the index should be created/dropped
      concurrently.
    * `:prefix` - specify an optional prefix for the index.
    * `:where` - specify conditions for a partial index.
    * `:comment` - adds a comment to the index.
  ## Examples
      # With no name provided, the name of the below index defaults to
      # idxginp_products_category
      create json_index("products", :category)
      # The name can also be set explicitly
      create json_index("products", :category, name: :my_special_name)
      # With no name provided, the name of the below index defaults to
      # idxgin_products_category_tags
      create json_index("products", ["category", "tags"])
      # Partial indexes are created by specifying a :where option, note that you need to use the necessary JSONb expressions:
      create json_index("account", :email_provider, where: "email_provider #>> '{email_provider,google,smtp_host}' = 'smtp.gmail.com'", name: :gmail_provider_index)
  """
  def json_index(table, columns, opts \\ [])

  def json_index(table, columns, opts) when is_atom(table) do
    json_index(Atom.to_string(table), columns, opts)
  end

  def json_index(table, column, opts) when is_binary(table) and is_atom(column) do
    validate_index_opts!(opts)
    opts = Keyword.put(opts, :using, "GIN")
    column_expr = "#{to_string(column)} jsonb_path_ops"

    index = struct(%Index{table: table, columns: [column_expr]}, opts)
    %{index | name: index.name || default_index_name(table, column, "idxginp")}
  end

  def json_index(table, [column | properties] = columns, opts)
      when is_binary(table) and is_list(columns) and is_list(opts) do
    validate_index_opts!(opts)
    opts = Keyword.put(opts, :using, "GIN")

    column_expr =
      properties
      |> Enum.map(&"'#{&1}'")
      |> List.insert_at(0, column)
      |> Enum.join(" -> ")
      |> then(fn e -> "(#{e})" end)

    index = struct(%Index{table: table, columns: [column_expr]}, opts)
    %{index | name: index.name || default_index_name(table, columns, "idxgin")}
  end

  defp validate_index_opts!(opts) when is_list(opts) do
    case Keyword.get_values(opts, :where) do
      [_, _ | _] ->
        raise ArgumentError,
              "only one `where` keyword is supported when declaring a partial index. " <>
                "To specify multiple conditions, write a single WHERE clause using AND between them"

      _ ->
        :ok
    end
  end

  defp default_index_name(table, columns, prefix) do
    [prefix, table, columns]
    |> List.flatten()
    |> Enum.map(&to_string(&1))
    |> Enum.map(&String.replace(&1, ~r"[^\w_]", "_"))
    |> Enum.map_join("_", &String.replace_trailing(&1, "_", ""))
    |> String.to_atom()
  end
end
