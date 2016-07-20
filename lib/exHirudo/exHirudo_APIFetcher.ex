defmodule ExHirudo.APIFetcher do
  use GenServer
  import ExHirudo.Mixfile
  require Logger

  def init(_) do
    :timer.send_interval(variables[:API_Checkinterval]*1000, :check_api)
    Process.register(self(), :api)
    {:ok, []}
  end

  def start_link(state, opts \\ []) do
    Logger.info("ExHirudo.APIFetcher Process started")
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:pop, _from, []) do
    {:reply, :empty ,[]}
  end

  def handle_cast(:push, []) do
    {:noreply, []}
  end

  def handle_info(:check_api, state) do
    Logger.info("Performing HTTP-API Check")
    ExHirudo.APIHandler.check_for_downloads
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
