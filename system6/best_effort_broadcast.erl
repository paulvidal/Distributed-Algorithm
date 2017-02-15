% Paul Vidal (pv14)

-module(best_effort_broadcast).
-export([start/1]).

start(Erb) ->
  receive
    {bind, Pl, N, Pls} ->
      Erb ! {bind, N, self()},
      next(Erb, Pl, Pls)
  end.

next(Erb, Pl, Pls) ->
  receive
    {beb_broadcast, M} ->
      [Pl ! {pl_send, Pl_send, M} || Pl_send <- Pls];

    {pl_deliver, M} ->
      Erb ! {beb_deliver, M}
  end,
  next(Erb, Pl, Pls).
