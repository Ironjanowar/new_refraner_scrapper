defmodule RefranerScrapper.Client do
  use Tesla

  def listado_client() do
    middlewares = [
      {Tesla.Middleware.BaseUrl, "https://cvc.cervantes.es"}
    ]

    Tesla.client(middlewares)
  end

  def get_letter(letter) do
    case listado_client() |> get("/lengua/refranero/listado.aspx", query: [letra: letter]) do
      {:ok, %{body: body}} -> {:ok, body}
      error -> error
    end
  end
end
