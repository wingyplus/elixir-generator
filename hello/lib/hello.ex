defmodule Hello do
  @moduledoc """
  Documentation for `Hello`.
  """

  def main() do
    Dagger.with_connection(fn dag ->
      {:ok, out} =
        dag
        |> Dagger.Client.hello()
        |> Dagger.Hello.hello()

      out
    end)
    |> IO.puts()
  end
end
