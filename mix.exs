defmodule Exyt.Mixfile do
  use Mix.Project

  @version "0.2.0"
  @project_url "https://www.github.com/justahero/exyt"

  def project do
    [
      app: :exyt,
      name: "Exyt",
      version: @version,
      elixir: "~> 1.4",
      description: description(),
      source_url: @project_url,
      homepage_url: @project_url,
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpotion],
      extra_applications: [:logger]
    ]
  end

  defp description do
    "An Elixir client library for the Youtube API v3"
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Sebastian Ziebell"],
      licenses: ["MIT"],
      links: %{github: @project_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1.0"},

      {:bypass, "~> 0.8", only: :test},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},

      {:excoveralls, "~> 0.9.0", only: :test},
      {:ex_doc, "~> 0.18.3", only: [:dev, :test, :docs]},
      {:earmark, "~> 1.2.4", only: [:dev, :test, :docs]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
