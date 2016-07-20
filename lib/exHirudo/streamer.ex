defmodule ExHirudo.Streamer do
  use GenServer
  import ExHirudo.Mixfile
  require(Logger)

  def handle_info(%HTTPoison.AsyncStatus{code: _, id: _}, {filename, _}) do
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
