defmodule Exyt.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @project_url "https://www.github.com/justahero/exyt"

  def project do
    [
      app: :exyt,
      name: "Exyt Youtube API client",
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
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
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end
end
