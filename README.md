# CallTimeouts


Little project for messing around with `GenServer.call/3` timeouts.

See the accompanying blog post, which is not yet written, for explanations.

In the meantime try the following:

```elixir
iex -S mix

ex(1)> Timesout.yawn(500)
** (exit) exited in: GenServer.call(Timesout, {:yawn, 500}, 100)
    ** (EXIT) time out
    (elixir) lib/gen_server.ex:774: GenServer.call/3
iex(1)> flush
{#Reference<0.473664931.3820486659.190859>, {:previous_call_count, 0}}
:ok

```

``` elixir
iex -S mix

iex(1)> Timesout.before_you_sleep(1_000)
{:previous_call_count, 0}
iex(2)> Timesout |> Process.whereis() |> :sys.get_state()
1
```

``` elixir
iex -S mix

iex(1)> Timesout |> Process.whereis() |> :sys.get_state()
0
iex(2)> CallsStuff.call_fun(fn -> Timesout.yawn(200) end)
:ok
iex(3)>
16:55:01.718 [error] GenServer CallsStuff terminating
** (stop) exited in: GenServer.call(Timesout, {:yawn, 200}, 100)
    ** (EXIT) time out
    (elixir) lib/gen_server.ex:774: GenServer.call/3
    (call_timeouts) lib/calls_stuff.ex:44: CallsStuff.handle_cast/2
    (stdlib) gen_server.erl:616: :gen_server.try_dispatch/4
    (stdlib) gen_server.erl:686: :gen_server.handle_msg/6
    (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
Last message: {:"$gen_cast", {:call_fun, #Function<20.99386804/0 in :erl_eval.expr/5>}}
State: {}
iex(3)> Timesout |> Process.whereis() |> :sys.get_state()
1
```


``` elixir
iex -S mix

iex(1)> fn -> Timesout.yawn(200) end |> CallsStuff.catching_function() |> CallsStuff.call_fun()
"About to..."
:ok
iex(2)> {:catch, :exit, {:timeout, {GenServer, :call, [Timesout, {:yawn, 200}, 100]}}}
"Really done"
{:call_reply_received, {:previous_call_count, 0}}

```
