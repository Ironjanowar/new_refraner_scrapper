defmodule RefranerScrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias RefranerScrapper.Stage.{LetterFetcher, LetterScrapper, SupervisorRefranScrapper}

  @impl true
  def start(_type, _args) do
    children = [
      LetterFetcher,
      LetterScrapper,
      SupervisorRefranScrapper
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RefranerScrapper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
