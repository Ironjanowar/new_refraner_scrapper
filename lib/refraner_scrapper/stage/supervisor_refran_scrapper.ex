defmodule RefranerScrapper.Stage.SupervisorRefranScrapper do
  use ConsumerSupervisor

  alias RefranerScrapper.Stage.LetterScrapper
  alias RefranerScrapper.RefranScrapper

  require Logger

  def start_link(_) do
    ConsumerSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      %{id: RefranScrapper, start: {RefranScrapper, :start_link, []}, restart: :transient}
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [{LetterScrapper, max_demand: 5, min_demand: 0}]
    ]

    Logger.info("Starting #{__MODULE__}")

    ConsumerSupervisor.init(children, opts)
  end
end
