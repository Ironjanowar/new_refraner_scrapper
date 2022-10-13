defmodule RefranerScrapper.Stage.LetterFetcher do
  use GenStage

  alias RefranerScrapper.Client

  @letters Enum.map(?A..?Z, &<<&1::utf8>>)

  def start_link(_) do
    GenStage.start_link(__MODULE__, @letters, name: __MODULE__)
  end

  def init(letters) do
    {:producer, letters}
  end

  def handle_demand(demand, letters) do
    demand_letters = Enum.take(letters, demand)

    %{events: events, retry_letters: retry_letters} = get_htmls(demand_letters)

    # Remove demanded letters and reinsert failed letters
    letters = letters -- demand_letters
    letters = retry_letters ++ letters

    {:noreply, events, letters}
  end

  defp get_htmls(letters) do
    {events, errors} =
      letters
      |> Enum.map(&create_task/1)
      |> Task.yield_many()
      |> Enum.split_with(&splitter/1)

    retry_letters = Enum.map(errors, &elem(&1, 1))

    %{events: events, retry_letters: retry_letters}
  end

  defp create_task(letter), do: Task.async(fn -> fetch_letter(letter) end)

  defp fetch_letter(letter) do
    case Client.get_letter(letter) do
      {:ok, body} -> {:ok, body}
      _ -> {:error, letter}
    end
  end

  defp splitter({:ok, _}), do: true
  defp splitter(_), do: false
end
