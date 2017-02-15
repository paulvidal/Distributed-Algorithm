TO RUN CODE for each task:

1) Go in the task directory

e.g.
$ cd system1

2) Use the Makefile to run the system with the right parameters

--------------------------------------------------------------------------------

Q1: system1 - Erlang Broadcast

To run system with 1000 Max_message and 3000 Timeout (3s)
$ make run1

To run system with 0 Max_message and 3000 Timeout (3s)
$ make run2

--------------------------------------------------------------------------------

Q2: system2 - PL Broadcast

To run system with 100 Max_message and 1000 Timeout (1s)
$ make run1

To run system with 0 Max_message and 1000 Timeout (1s)
$ make run2

--------------------------------------------------------------------------------

Q3: system3 - Best Effort Broadcast

To run system with 100 Max_message and 1000 Timeout (1s)
$ make run1

To run system with 0 Max_message and 1000 Timeout (1s)
$ make run2

--------------------------------------------------------------------------------

Q4: system4 - Unreliable Message Sending

To run system with 100 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run1_1

To run system with 100 Max_message and 1000 Timeout (1s) with Reliability 50
$ make run1_2

To run system with 100 Max_message and 1000 Timeout (1s) with Reliability 0
$ make run1_3

To run system with 0 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run2_1

To run system with 0 Max_message and 1000 Timeout (1s) with Reliability 50
$ make run2_2

To run system with 0 Max_message and 1000 Timeout (1s) with Reliability 0
$ make run2_3

--------------------------------------------------------------------------------

Q5: system5 - Faulty Process

To run system with 100 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run1

To run system with 0 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run2

--------------------------------------------------------------------------------

Q6: system6 - Eager Reliable Broadcast

To run system with 100 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run1

To run system with 0 Max_message and 1000 Timeout (1s) with Reliability 100
$ make run2
