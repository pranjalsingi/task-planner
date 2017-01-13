# task-planner

The task planner is an AI which is developed to plan task based on given pre-condtions and actions. 
The task planner uses partial graph planning to create a plan.

The planner is coded in LISP. It has several lisp files.

<b>initial.lisp</b>
It has the main logic which implements task planner.

<b>structure.lisp</b>
It has all the structs that would be used in the Lisp program.

<b>database.lisp</b>
It sets up the all the actions that would be used in the testcases to test different conditions and actions.

<b>test.lisp</b>
It has various testcases. It executes the initial.lisp with the current preconditions and actions of the testcase.
The test cases are arranged in the level of the difficulty from top to bottom.

# execution

load structure - (load structure.lisp)
load database - (load database.lisp)
load initial - (load initial.lisp)
execute testcases - (load test.lisp)
 
