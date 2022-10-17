defmodule RefranerScrapper do
  def scrap_letter_html(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("li")
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.reject(&String.starts_with?(&1, "listado"))
    |> Enum.take(10)
  end
end
