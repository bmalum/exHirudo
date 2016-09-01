defmodule ExHirudo.APIHandler do
  import ExHirudo.Mixfile
  require Logger

  def check_for_downloads do
    %HTTPoison.Response{body: body, headers: headers, status_code: status} = HTTPoison.get! variables[:api_endpoint]<>variables[:api_key]
    body_enc = ExJSON.parse(body, :to_map)
    downloading_packages(body_enc)
  end

  defp downloading_packages([package | other_packages]) do
    %{"key" => key, "links" => links, "hash" => hash, "name" => name, "state" => state} = package
    req_body = ExJSON.generate([data: %{package_name: name, hash: hash, old_state: state, new_state: :queued}])
    req_url = "http://127.0.0.1:4000/api/v1/"<>variables[:api_key]<>"package/"<>hash<>"/_update_package"
    req_url = String.to_charlist(req_url)
    return = :ibrowse.send_req(req_url,[{"Content-Type","application/json"}], :post, req_body)
    downloading_links(links)
    downloading_packages(other_packages)
  end

  defp downloading_packages([]) do
    # Terminating the download_packages recursion
  end

  defp downloading_links([link | other_links]) do
    GenServer.call(:download_pool, {:download, Dict.get(link, "link")}, 5000)
    downloading_links(other_links)
  end

  defp downloading_links([]) do
    # Terminating the download_links recursion 
  end

end
