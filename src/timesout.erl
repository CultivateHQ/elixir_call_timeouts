-module(timesout).

-behaviour(gen_server).

-export([start_link/0]).
-export([yawn/1, catching_fun/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2, code_change/3]).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, {}, []).

catching_fun(F) ->
    fun () ->
            try F() of
                Result ->
                    io:fwrite("Result: ~w~n", [Result])
            catch
                Err:Term ->
                    io:fwrite("Error occured ~w:~w~n", [Err, Term])
            end
    end.

yawn(Sleep) ->
    gen_server:call(?MODULE, {yawn, Sleep}, 100).

init(_) ->
    {ok, 0}.

handle_call({yawn, SleepTime}, _from, Count) ->
    timer:sleep(SleepTime),
    {reply, ok, Count + 1}.

handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
