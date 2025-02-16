# Experiment of Elixir Generator

## Usage

1. Initiate a project and add generator to it.

    ```
    $ mix new demo
    $ dagger init
    $ dagger install github.com/shykes/hello
    $ dagger client add --generator github.com/wingyplus/elixir-generator@main
    ```

2. Add `{:dagger, path: "./dagger_sdk"}` to the project.
3. Add this code below:

    ```elixir
    defmodule Demo do
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
    ```

4. Run it with `dagger run mix run -e 'Demo.main()'`, should see `hello, world!` out on the terminal.
