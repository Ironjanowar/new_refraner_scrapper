defmodule RefranerScrapper.Stage.LetterScrapper do
  use GenStage

  alias RefranerScrapper.Stage.LetterFetcher

  def start_link(_) do
    GenStage.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [{LetterFetcher, max_demand: 5}]}
  end

  def handle_events(_events, _from, state) do
    # TODO: Scrap and get links for refranes

    # Events should be already fetched refranes (only html)
    events = []
    {:noreply, events, state}
  end
end
