defmodule ExHirudo.Mixfile do
  use Mix.Project
  require(Logger)

  def project do
    [app: :exHirudo,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def variables do
  [
    download_workers: 1,
    API_Checkinterval: 6,   # in Seconds
    dl_path: "/Users/bMalum/Downloads/",
    api_endpoint: "http://demo3380079.mockable.io/",
    api_key: "2c664e6800b56b00e9244b05d953c54edfeb7eb6477bb2ac9a154d9f5ddee247/"
  ]
  end
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {ExHirudo, []},
    applications: [:logger,
                   :httpoison,
                   :expool
                   ]
    ]
  end

  # Dependencie#   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:exjson, "~> 0.5.0"},
   {:expool, "~> 0.2.0"}]
  end
end
