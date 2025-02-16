defmodule ElixirGenerator do
  @moduledoc """
  TODO: write me.
  """

  use Dagger.Mod.Object, name: "ElixirGenerator"

  defn generate_client(
         mod_source: Dagger.ModuleSource.t(),
         introspection_json: Dagger.File.t(),
         use_local_sdk: boolean()
       ) :: Dagger.Directory.t() do
    dag()
    |> Dagger.Client.directory()
    |> Dagger.Directory.with_directory("/dagger_sdk", sdk(),
      exclude: ["**/*"],
      include: ["LICENSE", "mix.exs", "mix.lock", "lib/**/*.exs", "!lib/dagger/gen"]
    )
    |> Dagger.Directory.with_directory(
      "/dagger_sdk/lib/dagger/gen",
      dagger_api(introspection_json)
    )
  end

  defn codegen() :: Dagger.Directory.t() do
    sdk()
    |> Dagger.Directory.directory("dagger_codegen")
  end

  defn sdk() :: Dagger.Directory.t() do
    dag()
    |> Dagger.Client.git("https://github.com/dagger/dagger.git")
    |> Dagger.GitRepository.branch("main")
    |> Dagger.GitRef.tree()
    |> Dagger.Directory.directory("sdk/elixir")
  end

  defn dagger_api(introspection_json: Dagger.File.t()) :: Dagger.Directory.t() do
    dag()
    |> Dagger.Client.container()
    |> Dagger.Container.from(
      "hexpm/elixir:1.18.2-erlang-27.2.2-alpine-3.21.2@sha256:8e513a83085989dd0befe35e170d51b41ee9e3b1ab0691868a3491759646ea62"
    )
    |> Dagger.Container.with_exec(~w"mix local.hex --force")
    |> Dagger.Container.with_exec(~w"mix local.rebar --force")
    |> Dagger.Container.with_mounted_file("/introspection.json", introspection_json)
    |> Dagger.Container.with_workdir("/codegen")
    |> Dagger.Container.with_mounted_directory(".", codegen())
    |> Dagger.Container.with_exec(~w"mix deps.get --only dev")
    |> Dagger.Container.with_exec(
      ~w"mix dagger.codegen generate --outdir /gen --introspection /introspection.json"
    )
    |> Dagger.Container.directory("/gen")
  end
end
