defmodule EctoPostgresJson.MixProject do
  use Mix.Project

  @source_url "https://github.com/emoragaf/ecto_postgres_json"
  @version "0.1.0"

  def project do
    [
      app: :ecto_postgres_json,
      version: @version,
      elixir: "~> 1.13",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      package: package(),
      docs: docs(),
      aliases: aliases(),
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
      {:ecto_sql, "~> 3.8.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.14.4", only: :test},
      {:mix_audit, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      name: "ecto_postgres_json",
      description: "Utilities for working with Postgres JSONb columns in Ecto",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      maintainers: ["Eduardo Moraga"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      name: "EctoPostgresJSON",
      source_ref: "v#{@version}",
      source_url: @source_url,
      canonical: "https://hexdocs.pm/ecto_postgres_json",
      api_reference: false,
      formatters: ["html"]
    ]
  end

  defp preferred_cli_env do
    [
      "check.all": :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test,
      "coveralls.json": :test,
      "coveralls.post": :test,
      "coveralls.xml": :test
    ]
  end

  defp aliases do
    [
      "check.all": [
        "format --check-formatted --dry-run",
        "credo --strict",
        "coveralls.html",
        "deps.audit"
      ]
    ]
  end
end
