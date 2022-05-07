defmodule EctoJsonIndex do
  @moduledoc """
  Documentation for `EctoJsonIndex`.
  """

  alias Ecto.Migration.Index

  @doc false
  def json_index(table, columns, opts \\ [])

  def json_index(table, columns, opts) when is_atom(table) do
    json_index(Atom.to_string(table), columns, opts)
  end

  def json_index(table, column, opts) when is_binary(table) and is_atom(column) do
    opts = Keyword.put(opts, :using, "GIN")
    column_expr = "#{to_string(column)} jsonb_path_ops"

    index = struct(%Index{table: table, columns: [column_expr]}, opts)
    %{index | name: index.name || default_index_name(table, column, "idxginp")}
  end

  def json_index(table, [column | properties]= columns, opts) when is_binary(table) and is_list(columns) and is_list(opts) do
    opts = Keyword.put(opts, :using, "GIN")
    column_expr =
      properties
      |> Enum.map(&("'#{&1}'"))
      |> List.insert_at(0, column)
      |> Enum.join(" -> ")
      |> then(fn e -> "(#{e})" end)

    index = struct(%Index{table: table, columns: [column_expr]}, opts)
    %{index | name: index.name || default_index_name(table, columns, "idxgin")}
  end

  defp default_index_name(table, columns, prefix) do
    [prefix, table, columns]
    |> List.flatten
    |> Enum.map(&to_string(&1))
    |> Enum.map(&String.replace(&1, ~r"[^\w_]", "_"))
    |> Enum.map(&String.replace_trailing(&1, "_", ""))
    |> Enum.join("_")
    |> String.to_atom
  end
end
