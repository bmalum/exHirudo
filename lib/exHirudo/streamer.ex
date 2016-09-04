#########################################
##   DEPRECATED - not needed anymore   ##
##   was used for HTTPosion            ##
#########################################

defmodule ExHirudo.Streamer do
  use GenServer
  import ExHirudo.Mixfile

  @moduledoc """
  This Modules allows us to Stream the File, sent via Messages from the
  corresponding "Download-Process", to the Disk without buffering in Memory
  (if the disk is fast enought).
  """

  @doc """
  Recieves the Status Code from the Async HTTPoison Process.
  TODO Error Handling!
  Returns `:noreply, state`
  """
  def handle_info(%HTTPoison.AsyncStatus{code: _, id: _}, {filename, _}) do
    {:noreply, {filename, nil}}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: headers}, {filename, file_pid}) do
      file_pid = File.open!(variables[:dl_path]<>filename, [:write, :append, :raw])
      {:noreply, {filename, file_pid}}
    end

    def handle_info(%HTTPoison.AsyncChunk{chunk: chunk, id: _}, {filename, file_pid}) do
      IO.binwrite(file_pid, chunk)
      {:noreply, {filename, file_pid}}
    end

    def handle_info(%HTTPoison.AsyncEnd{id: _}, {filename, file_pid}) do
      File.close(file_pid)
      {:stop, :normal, :finished, {filename, file_pid}}
    end

    def handle_info(_, state) do
      {:noreply, state}
    end
  end
