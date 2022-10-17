defmodule RefranerScrapper.Stage.LetterScrapper do
  use GenStage

  alias RefranerScrapper.Stage.LetterFetcher

  require Logger

  def start_link(_) do
    GenStage.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting #{__MODULE__}")

    {:producer_consumer, state, subscribe_to: [{LetterFetcher, max_demand: 1, min_demand: 0}]}
  end

  def handle_events(letter_htmls, _from, state) do
    Logger.info("[#{__MODULE__}] handle_events/3")

    endpoints =
      Enum.map(letter_htmls, fn html ->
        Task.async(fn -> RefranerScrapper.scrap_letter_html(html) end)
      end)
      |> Task.await_many()

    {:noreply, endpoints, state}
  end
end
