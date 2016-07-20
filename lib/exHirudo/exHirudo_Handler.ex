defmodule ExHirudo.APIHandler do

  def check_for_downloads do
    %HTTPoison.Response{body: body} = HTTPoison.get! "http://demo0038064.mockable.io/bmalum"
    body_map = ExJSON.parse(body, :to_map)
  end

  def begin_download(download_id) do
  end

  def finished_download(download_id) do
  end

end
