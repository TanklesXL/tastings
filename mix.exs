defmodule Tastings.MixProject do
  use Mix.Project

  @app :tastings

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.13",
      archives: [mix_gleam: "~> 0.4.0"],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases() |> MixGleam.add_aliases(),
      erlc_paths: ["build/dev/erlang/#{@app}/build"],
      erlc_include_path: "build/dev/erlang/#{@app}/include"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tastings.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6", override: true},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.16.0"},
      {:floki, "~> 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:gleam_stdlib, "~> 0.21"},
      {:gleam_httpc, "~> 1.1"},
      {:gleam_http, "~> 2.1"},
      {:gleeunit, "~> 0.6", runtime: false},
      {:justify, "~> 1.1.0"},
      {:gleam_erlang, "~> 0.8", override: true}
      # {:mix_gleam, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [setup: ["deps.get", "compile"], "assets.deploy": ["esbuild default --minify", "phx.digest"]]
  end
end
