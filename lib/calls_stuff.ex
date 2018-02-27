defmodule CallsStuff do
  @moduledoc """
  GenServer that is for calling another function in its process.
  """

  use GenServer
  require Logger

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    {:ok, %{}}
  end

  @doc """
  Wrap the function `fun` in a function that catches errors and
  exits. Logs out what's happening.
  """
  @spec catching_function(fun) :: fun
  def catching_function(fun) do
    fn ->
      try do
        log("About to...")
        result = fun.()
        log({"Done", result})
      catch
        err, term ->
          log({:catch, err, term})
      end

      log("Really done")
    end
  end

  @doc """
  Call the function in the process of this GenServer. Returns immediately, as we
  assume that we are messing with timeouts and we don't want _this_ to timeout.
  """
  @spec call_fun(fun) :: :ok
  def call_fun(fun) do
    GenServer.cast(@name, {:call_fun, fun})
  end

  def handle_cast({:call_fun, fun}, s) do
    fun.()
    {:noreply, s}
  end

  def handle_info({call_ref, reply}, s) when is_reference(call_ref) do
    log({:call_reply_received, reply})
    {:noreply, s}
  end

  defp log(log) do
    log
    |> inspect()
    |> Logger.info()
  end
end
