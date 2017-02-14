% Paul Vidal (pv14)

-module(pl).
-export([start/1]).

start(Beb) -> next(Beb).

next(Beb) ->
  receive
    {bind, N, Pls} ->
      Beb ! {bind, self(), N, Pls};

    {pl_send, Receiver, Message} ->
      Receiver ! {pl_receive, Message};

    {pl_receive, Message} ->
      Beb ! Message
  end,

  next(Beb).
