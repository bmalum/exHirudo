defmodule ExHirudo.Pipeline do
  require Logger
  import ExHirudo.Mixfile

  def findHost(url) do
    urlp = URI.parse(url)
    Logger.debug(urlp.authority)
    cond  do
      "ul.to" == urlp.authority -> ul_to_pipeline(url)
      "uploaded.net" == urlp.authority -> uploaded_net_pipeline(url)
      String.match?(urlp.authority, ~r/[a-zA-Z]*\.(uploaded.net)/) -> uploaded_net_pipeline(url)
      "share-online.bz" == urlp.authority -> share_online_bz_pipeline(url)
    end
  end

  def ul_to_pipeline(url) do
    uploaded_net_pipeline(url)
  end

  def uploaded_net_pipeline(url) do
    url = String.to_char_list(url)
    cookie = String.to_char_list(variables[:ul_to])
    {:ok, status, headers, body} = :ibrowse.send_req(url, [{:cookie, variables[:ul_to]}], :head, [], [])
    headers_map = Enum.into(headers, %{})
    case status do
      '302' ->  location = List.to_string(Map.get(headers_map, 'Location'))
                status = :redirect
                uploaded_net_pipeline(location)
      '200' ->  filename = ul_get_filename(headers_map)
                status = :online
                {status, url, filename, variables[:ul_to]}
      '404' ->  status = :offline
      _     -> status = :error
               Logger.error("Undefined HTTP Error")
    end
    end

    def share_online_bz_pipeline(url) do
      {:online, "some-file-name.xy"}
    end

    def base_pipeline(url) do
      Logger.debug("base.pipeline")
      urlp = URI.parse(url)
      filename = Path.absname(urlp.path)
      {:online, filename}
    end

    defp ul_get_filename(headers_map) do
      condis = List.to_string(Map.get(headers_map, 'Content-Disposition'))
      filename =
        case condis do
          nil ->  "no_name.xy"
          _ -> condis
          |> String.trim("attachment; filename=\"")
          |> String.trim_trailing("\"")
        end
        filename = variables[:dl_path]<>filename
        String.to_charlist(filename)
      end
  end
