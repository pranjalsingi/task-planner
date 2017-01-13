;; Pranjal Singi

(defun print-initial-state-list()
   (princ "The initial state is:")
   (terpri)
   (print-literals INITIAL_STATE_LIST)) 

(defun print-goal-list()
   (princ "The goal propositions are:")
   (terpri)
   (print-literals GOAL_LIST))

(defun testing ()
   (setf *print-level* nil)
   (setf *print-length* nil)
(terpri)(terpri) (princ "******************************* Test 1:") 
(terpri)(terpri)
   (setf ACTION_RECIPES
	  (list recipe_Cook
		recipe_Wrap)) 
   (setf INITIAL_STATE_LIST
	   (list prop_Garbage prop_CleanHands prop_Quiet)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Dinner prop_Present)) 
   (print-goal-list)
   (Task-planner)
(terpri)(terpri) (princ "******************************* Test 2:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
			       recipe_Wrap
			       recipe_Dolly2
			       recipe_BuyDolly
			       recipe_ReadDollyManual
			       recipe_Catch
			       recipe_Eat)) 
   (setf INITIAL_STATE_LIST
	  (list prop_Garbage prop_CleanHands prop_Quiet 
		prop_Have_Money prop_Have_Dolly_Manual)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage )) 
   (print-goal-list)
   (Task-planner)
 
(terpri)(terpri) (princ "******************************* Test 3:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
				recipe_Wrap
				recipe_Dolly2
				recipe_BuyDolly
				recipe_ReadDollyManual
				recipe_Catch
				recipe_Eat)) 
   (setf INITIAL_STATE_LIST
	   (list prop_Garbage prop_CleanHands prop_Quiet))
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage )) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "******************************* Test 4:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
				recipe_Wrap
				recipe_Dolly
				recipe_Catch
				recipe_Eat)) 
   (setf INITIAL_STATE_LIST
	   (list prop_Garbage prop_CleanHands prop_Quiet)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage prop_Dinner prop_Present)) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "******************************* Test 5:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
			       recipe_Wrap
			       recipe_Dolly2
			       recipe_BuyDolly
			       recipe_ReadDollyManual
			       recipe_Catch
			       recipe_Eat)) 
   (setf INITIAL_STATE_LIST
	  (list prop_Garbage prop_CleanHands prop_Quiet 
		prop_Have_Money prop_Have_Dolly_Manual)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage prop_Dinner prop_Present)) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "******************************* Test 6:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
			       recipe_Wrap
			       recipe_Carry
			       recipe_Dolly
			       recipe_Catch
			       recipe_Eat))  
   (setf INITIAL_STATE_LIST
	  (list prop_Garbage prop_CleanHands prop_Quiet)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage prop_Dinner prop_Present)) 
   (print-goal-list)
   (Task-planner)
   
(terpri)(terpri) (princ "******************************* Test 7:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
                              recipe_Wrap
                              recipe_Carry
                              recipe_Dolly2
                              recipe_BuyDolly
                              recipe_ReadDollyManual
                              recipe_Catch
                              recipe_Eat)) 
   (setf INITIAL_STATE_LIST
         (list prop_Garbage prop_CleanHands prop_Quiet)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage prop_Dinner prop_Present)) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "******************************* Test 8:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
                              recipe_Wrap
                              recipe_Carry
                              recipe_Dolly2
                              recipe_BuyDolly
                              recipe_ReadDollyManual
                              recipe_Catch
                              recipe_Eat)) 
   (setf INITIAL_STATE_LIST 
         (list prop_Ready prop_Hands_Free))
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Has_Ball prop_Stomach_Full))
   (print-goal-list)
   (Task-planner )
   

(terpri)(terpri) (princ "******************************* Test 9:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_Cook
                              recipe_Wrap
                              recipe_Carry
                              recipe_Dolly2
                              recipe_BuyDolly
                              recipe_ReadDollyManual
                              recipe_Catch
                              recipe_Eat)) 
   (setf INITIAL_STATE_LIST
         (list prop_Garbage prop_CleanHands prop_Quiet prop_Have_Money prop_Have_Dolly_Manual)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_Not_Garbage prop_Dinner prop_Present
prop_CleanHands)) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "******************************* Test 10:") 
(terpri)(terpri)
   (setf ACTION_RECIPES (list recipe_A
                              recipe_B
                              recipe_C
                              recipe_D
                              recipe_E
                              recipe_F
                              recipe_Play)) 
   (setf INITIAL_STATE_LIST
         (list prop_Q1)) 
   (print-initial-state-list)
   (setf GOAL_LIST (list prop_P4 prop_P5 )) 
   (print-goal-list)
   (Task-planner)

(terpri)(terpri) (princ "*******************************")
(terpri)
(terpri)
    (princ "ALL TESTCASES COMPLETED!!")
)
