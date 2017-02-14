% Paul Vidal (pv14)

-module(process).
-export([start/2]).

start(Number, Sys) ->
  process_flag(trap_exit, true),
  App = spawn_link(app, start, [Number]),
  Beb = spawn(best_effort_broadcast, start, [App]),
  Pl = spawn(pl, start, [Beb]),
  Sys ! {bind_pl, Pl},
  await_termination(Sys).

await_termination(Sys) ->
  receive
    {'EXIT', _, _} -> Sys ! process_terminated
  end.
