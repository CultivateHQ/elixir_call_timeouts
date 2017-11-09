defmodule Timesout do
  @moduledoc """
  GenServer to help explore `GenServer.call/3` timeouts.

  To save hanging around, each call timesout after 100 millisconds
  """
  use GenServer



  @name __MODULE__
  @timeout 100

  def start_link() do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    {:ok, 0}
  end

  @doc """
  Call the process and leeps for `sleep` milliseconds. If `sleep` > 100, or the
  GenServer is otherwise blocked, then the call should timeout. Returns the number of
  calls received by the GenServer, prior ot this one.
  """
  @spec yawn(integer) :: integer
  def yawn(sleep) do
    GenServer.call(@name, {:yawn, sleep}, @timeout)
  end

  @doc """
  Calls the process and returns the number of calls received by the GenServer and returns the number
  of calls received prior to this one.

  After returning it sleeps for `sleep` milliseconds. Unless the GenServer is otherwise blocked, it
  should not timeout
  """
  @spec before_you_sleep(integer) :: integer
  def before_you_sleep(sleep) do
    GenServer.call(@name, {:before_you_sleep, sleep}, @timeout)
  end

  def handle_call({:yawn, sleep}, _from, call_count) do
    :timer.sleep(sleep)
    {:reply, {:previous_call_count, call_count}, call_count + 1}
  end

  def handle_call({:before_you_sleep, sleep}, from, call_count) do
    GenServer.reply(from, {:previous_call_count, call_count})
    :timer.sleep(sleep)
    {:noreply, call_count + 1}
  end
end
