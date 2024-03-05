#!/usr/bin/env -S ERL_FLAGS=+B elixir
Mix.install([])

defmodule Counter do
  @moduledoc """

  ## Usage

      $ bin/counter --help

  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, 0}
  end

  def handle_call(["add", n], _from, count) do
    n = String.to_integer(n)
    count = count + n
    {:reply, count, count}
  end

  def handle_call(["sub", n], _from, count) do
    n = String.to_integer(n)
    count = count - n
    {:reply, count, count}
  end

  def main(args \\ System.argv()) do
    Counter
    |> GenServer.call(args)
    |> IO.puts()
  end
end

if System.get_env("SERVER") == "true" do
  System.argv()
  |> Counter.start_link()
  Process.sleep(:infinity)
else
  Counter
  |> GenServer.call(System.argv())
  |> IO.puts()
end
