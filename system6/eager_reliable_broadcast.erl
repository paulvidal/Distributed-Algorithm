% Paul Vidal (pv14)

-module(eager_reliable_broadcast).
-export([start/1]).

start(App) ->
  receive
    {bind, N, Beb} ->
      App ! {bind, N, self()},
      next(App, Beb, [])
  end.

next(App, Beb, Delivered) ->
  receive
    {erb_broadcast, M} ->
      broadcast(Beb, self(), M),
      next(App, Beb, Delivered);

    {beb_deliver, {Sender, M}} ->
      case lists:member(M, Delivered) of
        % If we have seen the message, ignore it
        true -> next(App, Beb, Delivered);

        % If first time we see message, re-broadcast it
        false ->
          App ! M,
          broadcast(Beb, Sender, M),
          next(App, Beb, Delivered ++ [M])
      end
  end.

broadcast(Beb, Sender, M) ->
  Beb ! {beb_broadcast, {Sender, M}}.
