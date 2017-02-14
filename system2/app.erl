% Paul Vidal (pv14)

-module(app).
-export([start/1]).

start(Number) ->
  receive
    {bind_pls, Pl, Pls} -> task_start(Number, Pl, Pls)
  end.

task_start(Number, Pl, Pls) ->
  receive
    {task1, start, Message_left, Timeout} ->
      PlCount = length(Pls),
      Status_list =
        [{SenderNumber, {0, 0}} || SenderNumber <- lists:seq(1, PlCount)],
      Status = maps:from_list(Status_list),
      timer:send_after(Timeout, timeout),
      next(Number, Pl, Pls, Message_left, Status, Message_left)
  end.

next(Number, Pl, Pls, Message_left, Status, NoLimit) ->
  receive
    {message, FromNumber} ->
      New_status = update_receive(FromNumber, Status),
      next(Number, Pl, Pls, Message_left, New_status, NoLimit);

    timeout -> print_summary(Number, Status)

  after 0 ->
    % If no message in the queue, broadcast new messages until limit reached
    broadcast(Number, Pl, Pls, Message_left, Status, NoLimit)
  end.

% Case where no message limit (Max_messages is 0)
broadcast(Number, Pl, Pls, 0, Status, 0) ->
  next(Number, Pl, Pls, 1, Status, 0);

% Case where message limit exceeded (Max_messages reached)
broadcast(Number, Pl, Pls, 0, Status, NoLimit) ->
  next(Number, Pl, Pls, 0, Status, NoLimit);

% Case where no limit achieved, send messages to all other processes
broadcast(Number, Pl, Pls, Message_left, Status, NoLimit) ->
  New_status = send_messages(Number, Pl, Pls, Status),
  next(Number, Pl, Pls, Message_left - 1, New_status, NoLimit).

% Send a message to all processes and update the map
send_messages(Number, Pl, Pls, Status) ->
  [Pl ! {pl_send, Pl_send, {message, Number}} || Pl_send <- Pls],

  maps:from_list([begin
                    {ToCount, FromCount} = maps:get(ToNumber, Status),
                    {ToNumber, {ToCount + 1, FromCount}}
                  end
                  || ToNumber <- lists:seq(1, length(Pls))]).

% Update the receive count in the map
update_receive(FromNumber, Status) ->
  {ToCount, FromCount} = maps:get(FromNumber, Status),
  maps:update(FromNumber, {ToCount, FromCount + 1}, Status).

% Print summary of process interaction
print_summary(Number, Status) ->
  Summary = [io_lib:format(" {~p, ~p}", [To, From])
            || {_, {To, From}} <- maps:to_list(Status)],
  io:format(io_lib:format("~p:", [Number]) ++ Summary ++ "~n").
