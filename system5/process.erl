% Paul Vidal (pv14)

-module(process).
-export([start/2]).

start(Number, Sys) ->
  process_flag(trap_exit, true),
  App = spawn_link(app, start, [Number]),
  Beb = spawn(best_effort_broadcast, start, [App]),
  Pl = spawn(pl, start, [Beb]),
  Sys ! {bind_pl, Pl},
  await_termination(Sys, App, Beb, Pl).

await_termination(Sys, App, Beb, Pl) ->
  receive
    stop -> stop_system(App, Beb, Pl);

    {'EXIT', _, _} ->
      stop_system(App, Beb, Pl),
      Sys ! process_terminated
  end.

stop_system(App, Beb, Pl) ->
  exit(Pl, stop),
  exit(Beb, stop),
  exit(App, stop).
