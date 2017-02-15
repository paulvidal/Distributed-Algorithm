% Paul Vidal (pv14)

-module(system6).
-export([start/1]).

start([Arg1, Arg2, Arg3 | _]) ->
  N = 5,
  {Max_messages, _} = string:to_integer(atom_to_list(Arg1)),
  {Timeout, _} = string:to_integer(atom_to_list(Arg2)),
  {Reliability, _} = string:to_integer(atom_to_list(Arg3)),

  % Spawn the N process
  Processes =
    [spawn(process, start, [Number, self()]) || Number <- lists:seq(1, N)],
  % Collect the Pl for all apps
  Pls = get_pls([], N),
  % Bind the processes
  [Pl ! {bind, N, Pls, Reliability} || Pl <- Pls],
  % Send a single message to each Pl
  [Pl ! {pl_receive, {0, {task1, start, Max_messages, Timeout}}} || Pl <- Pls],
  % STOP process 3 after 5 milliseconds
  stop_process(3),
  await_termination(Processes, N).

get_pls(Pls, 0) -> Pls;
get_pls(Pls, N) ->
  receive
    {bind_pl, Pl} -> NewPls = lists:append(Pls, [Pl])
  end,
  get_pls(NewPls, N-1).

stop_process(Process_number) ->
  timer:send_after(5, {stop, Process_number}).

await_termination(_, 0) -> halt();
await_termination(Processes, N) ->
  receive
    process_terminated -> skip;

    {stop, Process_number} ->
      Process = lists:nth(Process_number, Processes),
      Process ! stop
  end,

  await_termination(Processes, N-1).
