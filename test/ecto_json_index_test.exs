defmodule EctoPostgresJson.IndexTest do
  use ExUnit.Case
  use Ecto.Migration

  import EctoPostgresJson.Index
  alias Ecto.Migration.Index
  alias EctoSQL.TestRepo
  alias Ecto.Migration.Runner

  setup meta do
    config = Application.get_env(:ecto_sql, TestRepo, [])
    Application.put_env(:ecto_sql, TestRepo, Keyword.merge(config, meta[:repo_config] || []))
    on_exit(fn -> Application.put_env(:ecto_sql, TestRepo, config) end)
  end

  setup meta do
    direction = meta[:direction] || :forward
    log = %{level: false, sql: false}
    args = {self(), TestRepo, TestRepo.config(), __MODULE__, direction, :up, log}
    {:ok, runner} = Runner.start_link(args)
    Runner.metadata(runner, meta)
    {:ok, runner: runner}
  end

  test "creates a JSONb column index" do
    assert json_index(:posts, :title) ==
             %Index{
               using: "GIN",
               table: "posts",
               unique: false,
               name: :idxginp_posts_title,
               columns: ["title jsonb_path_ops"]
             }
  end

  test "creates a JSONb key index" do
    assert json_index(:posts, ["tags", "properties"]) ==
             %Index{
               using: "GIN",
               table: "posts",
               unique: false,
               name: :idxgin_posts_tags_properties,
               columns: ["(tags -> 'properties')"]
             }
  end

  test "raises if given multiple 'where' clauses for an index" do
    assert_raise ArgumentError, fn ->
      json_index(:posts, :title, where: "status = 'published'", where: "deleted = 'false'")
    end
  end

  test "forward: creates an index" do
    create(json_index(:posts, [:title]))
    flush()
    assert {:create, %Index{}} = last_command()
  end

  defp last_command(), do: Process.get(:last_command)
end
