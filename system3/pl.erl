% Paul Vidal (pv14)

-module(pl).
-export([start/1]).

start(Beb) ->
  receive
    {bind, N, Pls} ->
      Beb ! {bind, self(), N, Pls},
      next(Beb)
  end.

next(Beb) ->
  receive
    {pl_send, Receiver, Message} ->
      Receiver ! {pl_receive, Message};

    {pl_receive, Message} ->
      Beb ! {pl_deliver, Message}
  end,

  next(Beb).
