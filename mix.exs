defmodule ExHirudo.Mixfile do
  use Mix.Project
  require(Logger)

  def project do
    [app: :exHirudo,
     version: "0.0.1",
     elixir: "~> 1.3",
     name: "ExHirudo",
     source_url: "https://github.com/bmalum/exHirudo",
     homepage_url: "http://exhirudo.bmalum.org",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def variables do
  [
    download_workers: 1,
    API_Checkinterval: 5,   # in Seconds
    dl_path: "/Users/bMalum/Downloads/",
    api_endpoint: "http://demo3380079.mockable.io/",
    api_key: "2c664e6800b56b00e9244b05d953c54edfeb7eb6477bb2ac9a154d9f5ddee247/",
    ul_to: "login=%26id%3D2243662%26pw%3Db23d310f6f89d9a4ae8f5856a946f2caa28419ca%26cks%3D64ec890a4bdb"
  ]
  end
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {ExHirudo, []},
    applications: [:logger,
                   :httpoison,
                   :expool,
                   :inets,
                   :ibrowse
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
   {:expool, "~> 0.2.0"},
 {:ex_doc, "~> 0.12", only: :dev},
{:ibrowse, "~> 4.2"}]
  end
end
