defmodule ExHirudo.DownloadWorkerPool do
  use GenServer
  import ExHirudo.Mixfile
  require Logger

  def init(_) do
    {:ok, pid} = Expool.create_pool(variables[:download_workers], name: :download_worker_pool)
    Process.register(self(), :download_pool)
    {:ok, pid}
  end

  def start_link(state, opts \\ []) do
    Logger.info("ExHirudo.PoolHandler Process started with PID #{inspect(self())} and registered as :download_pool")
    Logger.info(inspect(state))
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call({:download, url}, _from, pid) do
    Logger.info("Downloading #{url}")
    {:ok, pid} = Expool.submit(:download_worker_pool,
    fn ->
      blob_download(url)
    end)
    {:reply, pid, []}
  end

  # Worker Functions
  defp blob_download(url) do
    {state, url, filename, cookie} = ExHirudo.Pipeline.findHost(url)
    cookie = String.to_charlist(cookie)
    Logger.debug("Started Download")
      {:ok, status, headers, body} = :ibrowse.send_req(url, [{:cookie, cookie}], :get, [], [{:save_response_to_file, filename}])
      Logger.debug "Finished Download"
    end
  end
