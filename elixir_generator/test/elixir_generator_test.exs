defmodule ElixirGeneratorTest do
  use ExUnit.Case
  doctest ElixirGenerator

  test "greets the world" do
    assert ElixirGenerator.hello() == :world
  end
end
