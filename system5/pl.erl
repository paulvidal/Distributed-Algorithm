% Paul Vidal (pv14)

-module(pl).
-export([start/1]).

start(Beb) ->
  receive
    {bind, N, Pls, Reliability} ->
      Beb ! {bind, self(), N, Pls},
      next(Beb, Reliability)
  end.

next(Beb, Reliability) ->
  receive
    {pl_send, Receiver, Message} ->
      send(Receiver, Message, Reliability);

    {pl_receive, Message} ->
      Beb ! {pl_deliver, Message}
  end,

  next(Beb, Reliability).

send(Receiver, Message, Reliability) ->
  Random = rand:uniform(100),
  if (Random =< Reliability) -> Receiver ! {pl_receive, Message};
     true -> skip
  end.
