defmodule EctoJsonIndex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_json_index,
      version: "0.1.0",
      elixir: "~> 1.13",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.8.1"}
    ]
  end
end
