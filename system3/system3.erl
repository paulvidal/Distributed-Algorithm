% Paul Vidal (pv14)

-module(system3).
-export([start/1]).

start([Arg1, Arg2 | _]) ->
  N = 5,
  {Max_messages, _} = string:to_integer(atom_to_list(Arg1)),
  {Timeout, _} = string:to_integer(atom_to_list(Arg2)),

  % Spawn the N process
  [spawn(process, start, [Number, self()]) || Number <- lists:seq(1, N)],
  % Collect the Pl for all apps
  Pls = get_pls([], N),
  % Bind the processes
  [Pl ! {bind, N, Pls} || Pl <- Pls],
  % Send a single message to each Pl
  [Pl ! {pl_receive, {task1, start, Max_messages, Timeout}} || Pl <- Pls],
  await_termination(N).

get_pls(Pls, 0) -> Pls;
get_pls(Pls, N) ->
  receive
    {bind_pl, Pl} ->
      NewPls = lists:append(Pls, [Pl]),
      get_pls(NewPls, N-1)
  end.

await_termination(0) -> halt();
await_termination(N) ->
  receive
    process_terminated -> await_termination(N-1)
  end.
