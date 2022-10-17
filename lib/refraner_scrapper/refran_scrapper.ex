defmodule RefranerScrapper.RefranScrapper do
  def start_link(endpoint) do
    Task.start_link(fn ->
      IO.inspect(endpoint, label: "endpoint")
    end)
  end
end
