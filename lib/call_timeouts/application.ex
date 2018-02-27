defmodule CallTimeouts.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Timesout, []),
      worker(:timesout, []),
      worker(CallsStuff, [])
    ]

    opts = [strategy: :one_for_one, name: CallTimeouts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
