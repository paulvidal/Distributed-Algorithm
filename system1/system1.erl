% Paul Vidal (pv14)
%
% RESULTS:
%
% 1) {task1, start, 1000, 3000} outputs
%
%    4: {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000}
%    2: {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000}
%    3: {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000}
%    5: {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000}
%    1: {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000} {1000, 1000}
%
% This output seems behaving properly as we have set a message limit so all the
% message were correctly sent and processes before the timeout
%
% 2) {task1, start, 0, 3000} outputs
%
%    2: {694766, 714399} {694766, 694766} {694766, 689296}
%       {694766, 661053} {694766, 702355}
%    4: {661054, 714399} {661054, 694766} {661054, 689297}
%       {661054, 661054} {661054, 702356}
%    1: {714399, 714399} {714399, 694766} {714399, 689296}
%       {714399, 661053} {714399, 702355}
%    5: {702358, 714399} {702358, 694766} {702358, 689297}
%       {702358, 661054} {702358, 702357}
%    3: {689297, 714399} {689297, 694766} {689297, 689297}
%       {689297, 661053} {689297, 702356}
%
% This output is more interesting as we see the huge amount of broadcasts
% the erlang can perform in 3s, when no limit is set (more than
% 200,000 message/s). It is interesting to note that when the timeout occurs,
% some message are still waiting to be process, which can be seen in the
% asymetry of the send and processed message of a process to itself.
% For example, process 5 sent 702358 to itself but only received 702357.

-module(system1).
-export([start/1]).

start([Arg1, Arg2 | _]) ->
  N = 5,
  {Max_messages, _} = string:to_integer(atom_to_list(Arg1)),
  {Timeout, _} = string:to_integer(atom_to_list(Arg2)),

  % Spawn the N processes
  Processes =
    [spawn_link(process, start, [Number]) || Number <- lists:seq(1, N)],
  % Bind the processes
  [Process ! {bind, Processes} || Process <- Processes],
  % Send a single message to each process
  [Process ! {task1, start, Max_messages, Timeout} || Process <- Processes],
  await_termination(N).

% Count the number of process that exit and stop when all are finished
await_termination(0) -> halt();
await_termination(N) ->
  receive
    {'EXIT', _, _} -> await_termination(N-1)
  end.
