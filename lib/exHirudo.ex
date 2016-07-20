defmodule ExHirudo do

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      worker(ExHirudo.APIFetcher, restart: :transient),
      worker(ExHirudo.DownloadWorkerPool, restart: :transient)
    ]
    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  end

end
