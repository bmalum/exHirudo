defmodule ExHirudo.APIHandler do
  import ExHirudo.Mixfile

  def check_for_downloads do
    %HTTPoison.Response{body: body, headers: headers, status_code: status} = HTTPoison.get! variables[:api_endpoint]<>variables[:api_key]
    url = ExJSON.parse(body, :to_map)
    |> Dict.get("url")
    GenServer.call(:download_pool, {:download, url}, 5000)
  end

  def begin_download(download_id) do
  end

  def finished_download(download_id) do
  end

end
