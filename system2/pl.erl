% Paul Vidal (pv14)

-module(pl).
-export([start/1]).

start(App) -> next(App).

next(App) ->
  receive
    {bind, Pls} ->
      App ! {bind, self(), Pls};

    {pl_send, Receiver, Message} ->
      Receiver ! {pl_receive, Message};

    {pl_receive, Message} ->
      App ! Message
  end,

  next(App).
