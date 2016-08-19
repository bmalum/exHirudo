defmodule ExHirudo.Streamer do
  use GenServer
  import ExHirudo.Mixfile

  def handle_info(%HTTPoison.AsyncStatus{code: _, id: _}, {filename, _}) do
    {:noreply, {filename, nil}}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk, id: _}, {filename, file_pid}) do
    IO.binwrite(file_pid, chunk)
    {:noreply, {filename, file_pid}}
  end

  def handle_info(%HTTPoison.AsyncEnd{id: _}, {filename, file_pid}) do
    File.close(file_pid)
    {:stop, :normal, :finished, {filename, file_pid}}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: headers}, {filename, file_pid}) do
    headers_map = Enum.into(headers, %{})
    condis = Map.get(headers_map, "Content-Disposition")
    case condis do
      nil -> filename = "filename.xy"
      _ ->
      filename = condis
      |> String.trim("attachment; filename=\"")
      |> String.trim_trailing("\"")
    end
    IO.inspect filename
    file_pid = File.open!(variables[:dl_path]<>filename, [:write, :append, :raw])
    {:noreply, {filename, file_pid}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
