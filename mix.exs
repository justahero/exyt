defmodule Exyt.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @project_url "https://www.github.com/justahero/exyt"

  def project do
    [
      app: :exyt,
      name: "Exyt",
      version: @version,
      elixir: "~> 1.4",
      description: description(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "An Elixir client library for the Youtube API v3"
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme"
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
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
