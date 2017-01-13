;;Pranjal Singi

; ActionRecipes is a global variable, containing a list of action_recipe 
;   structures giving the preconditions and effects of actions

; goal_list is a global variable that is a list of structures of
;    type literal

; initial_state_list is a global variable that is a list of structures 
;    of type literal

; Assumptions: actions, preconditions, and effects have no parameters

(defun Task-planner ()
; goal_list and initial_state_list are global variables 
; goal_list is a list of structures of type literal that constitute the goal
; initial_state_list is a list of structures of type literal that are true 
;   in the initial world
; ActionRecipes is a global variable containing a list of action_recipe
;   structures giving the action definitions for this problem
; Return a partially ordered plan for achieving goal_list
(let* ((start_node
         (make-plan_node 
              :name (gensym)
              :act (make-action 
                       :act_name 'START
                       :parameters nil)
              :preconditions nil
              :effects 
                 initial_state_list))
       (goal_node
          (make-plan_node
               :name (gensym)
               :act (make-action
                       :act_name 'FINISH
                       :parameters nil)
               :preconditions
                  goal_list
               :effects nil))
        (init_partial_plan
           (make-partial_plan 
                :plan_nodes (list start_node goal_node)
                :causal_links nil
                :order_constraints
                   (list (make-order_constraint
                            :before_node start_node
                            :after_node goal_node))
                :open_precs
                   (mapcar #'(lambda(x)(make-open_precondition
                                         :precondition x
                                         :node goal_node))
                           (plan_node-preconditions goal_node)))))
   (search-graph (list init_partial_plan))))
          
(defun search-graph (open_list)
; open_list is a list of partial plans that remain to be expanded
; outpit the results of finding a plan that achieves the propositions
;    in the global variable goal_list; the propositions in
;    the global variable initial_state_list describe what is
;    true in the initial state.  The initial state only contains
;    propositions that are needed for the problem.  Do not assume 
;    anything about other propositions.
   (cond ((null open_list) (princ "**** FAILURE****") 'FAILURE)
         (t (let ((goal (complete-plan? open_list)))
              (if goal (output-results goal)
                       (let ((part_plan (select open_list)))
                         (search-graph (process-partial-plan 
                                         part_plan
                                         (remove-from-open part_plan open_list)))))))))

(defun complete-plan? (open_list)
; open_list is a list of structures of type partial_plan
; if any of these is a complete plan (a plan with no open
;   preconditions), return that partial plan

;; Checks if open-list is Null- if yes then return nil
;;checks if the there is any open-precs for the first element of the open-list, 
;if not then return the first element of the list
;;or else just call complete-plan? after removing the first element
	(cond ((null open_list) nil)
		((null (partial_plan-open_precs (car open_list))) (car open_list))
		(t (complete-plan? (cdr open_list)))))

(defun select (open_list)
; selects the partial plan on open_list that has the fewest actions
; and returns it

	(let ((minValue (getCountOfNodes (partial_plan-plan_nodes (car open_list)))))
		;(print (cdr open_list))
		(advanceSelect (cdr open_list) (car open_list) minValue)))
	
(defun getCountOfNodes(plan_node_list)
	(cond ((null plan_node_list) 0)
		(t (+ 1 (getCountOfNodes (cdr plan_node_list))))))
		
(defun advanceSelect(open_list partial_plan_node minValue)
	(cond ((null open_list) partial_plan_node)
		((let ((val (getCountOfNodes (partial_plan-plan_nodes (car open_list)))))
		(> minValue val) (advanceSelect (cdr open_list) (car open_list) val)))
		(t advanceSelect (cdr open-list) partial_plan_node minValue)))


(defun remove-from-open (part_plan open_list)
; open_list is a list of structures of type partial_plan
; part_plan is a structure of type partial_plan
; returns the result of removing part_plan from open_list
   (cond((null open_list) nil)
        ((equal part_plan (car open_list))
          (cdr open_list))
        (t (cons (car open_list) (remove-from-open part_plan (cdr open_list))))))

(defun select-prec (precs)
; precs is a list of structures of type open_precondition
; select one of them and return it
(car precs))



(defun process-partial-plan (part_plan open_list)
(setf *print-level* nil)
(setf *print-length* nil)
(terpri)
(terpri)
;(princ "*** The partial plan that I have selected to work on is the following:")
;(terpri)(terpri)
;(pprint part_plan)
;(terpri)
;(terpri)
;(princ "Here is what this partial plan represents")
;(terpri)
;(terpri)
;(output-results part_plan)
;(break "have entered process-partial-plan")
; part_plan is a partial plan that is to be worked on
; open_list is a list of the other partial plans that have been constructed
; return a new open_list that consists of the partial plans currently
;   on open_list along with those generated by addressing one of the
;   open preconditions of part_plan
    (let*((open_prec (select-prec (partial_plan-open_precs part_plan)))
          (action_nodes_existing (find-existing-nodes-with-action 
                                (open_precondition-precondition open_prec)
                                (partial_plan-plan_nodes part_plan)))
          (action_nodes_new (find-new-nodes-with-action
                                (open_precondition-precondition open_prec)
                                ACTION_RECIPES)))
                        
       (expand-partial-plan-with-new-actions 
          part_plan
          open_prec              
          (expand-partial-plan-with-existing-actions 
                part_plan
                open_prec
                open_list 
                action_nodes_existing) 
          action_nodes_new)))

(defun find-existing-nodes-with-action (literal plan_nodes)
; literal is a structure of type literal
; plan_nodes is a list of plan_nodes
; return a list of those members of plan_nodes with an effect matching literal
   (cond ((null plan_nodes) nil)
         ((literal-is-member-of literal (plan_node-effects (car plan_nodes)))
             (cons (car plan_nodes)
                   (find-existing-nodes-with-action 
                           literal
                          (cdr plan_nodes))))
         (t (find-existing-nodes-with-action literal (cdr plan_nodes)))))

(defun find-new-nodes-with-action (literal action_recipes)
; literal is a structure of type literal
; action_recipes is a list of structures of type action_recipe
; return a list of newly constructed plan nodes for each new action that has 
;    an effect matching literal
; a list of available action definitions is given in the global
;    variable action_recipes 
   (cond ((null action_recipes) nil)
         ((is-effect-of-action-recipe literal (car action_recipes))
              (cons (make-plan_node
                      :name (gensym)
                      :act (action_recipe-act (car action_recipes))
                      :preconditions (action_recipe-preconditions
                                          (car action_recipes))
                      :effects (action_recipe-effects
                                          (car action_recipes)))
                    (find-new-nodes-with-action 
                          literal (cdr action_recipes))))
         (t (find-new-nodes-with-action literal (cdr action_recipes)))))

(defun expand-partial-plan-with-existing-actions 
   (part_plan open_prec open_list action_nodes_existing)
; part_plan is a structure of type partial_plan
; open_prec is a structure of type open_precondition
; open_list is a list of partial plans
; action_nodes_existing is a list of structures of type plan_node
;    that are already in part_plan and which represent an action whose
;    effect matches open_prec
; return open_list with the addition of new partial plans (structures of 
;    type partial_plan) that represent expansions of part_plan that satisfy 
;    open_prec
; any new partial plans added to open_list must be consistent

;;Checks the action_nodes_existing. If null then return the open_list
;; If not null then make a new partial plan. Copy te causal links, order constrains and action Preconditions so that
;; there are new open preconditions for the added action. Call this function again adding the new partial plan to the
;; to the open list and reducing the action_nodes_existing.
	(cond ((null action_nodes_existing) open_list)
		(t (let* ((action (car action_nodes_existing))
		            (causal (make-causal_link
					            :plan_node_1 action
					            :plan_node_2 (open_precondition-node open_prec)
					            :protected_prop (open_precondition-precondition open_prec)))
					(order (is-constraint-existing? (make-order_constraint
					            :before_node action
					            :after_node (open_precondition-node open_prec)) (partial_plan-order_constraints part_plan)))
		            (new_part_plan (make-partial_plan
									:plan_nodes (partial_plan-plan_nodes part_plan)
									:causal_links (cons causal (partial_plan-causal_links part_plan))
									:order_constraints (append order (partial_plan-order_constraints part_plan))
									:open_precs (remove-precondition open_prec 
									        (partial_plan-open_precs part_plan))))
					(consistent_plan (consistent? new_part_plan)))
					
					(cond ((null consistent_plan) (expand-partial-plan-with-existing-actions
														   part_plan
														   open_prec
														   (cons new_part_plan open_list)
														   (cdr action_nodes_existing)))
						(t (expand-partial-plan-with-existing-actions
							   part_plan
							   open_prec
							   (append (make-consistent consistent_plan (list new_part_plan)) open_list)
							   (cdr action_nodes_existing))))
			))))

(defun expand-partial-plan-with-new-actions 
    (part_plan open_prec open_list action_nodes_new)
; part_plan is a structure of type partial_plan
; open_prec is a structure of type open_precondition
; open_list is a list of partial plans
; action_nodes_new is a list of structures of type plan_node that each
;    represent an action whose effect matches open_prec and which are 
;    not already in part_plan
; return open_list with the addition of new partial plans (structures 
;    of type partial_plan) that represent expansions of part_plan that 
;    satisfy open_prec
; any new partial plans added to open list must be consistent

;;Checks the action_nodes_new. If null then return the open_list
;; If not null then make a new partial plan. Copy the causal links, order constrains and action Preconditions so that
;; there are new open preconditions for the added action. Call this function again adding the new partial plan to the
;; to the open list and reducing the action_nodes_new.
	(cond ((null action_nodes_new) open_list)
		(t (let*((action (car action_nodes_new))
		            (causal (make-causal_link
					            :plan_node_1 action
					            :plan_node_2 (open_precondition-node open_prec)
					            :protected_prop (open_precondition-precondition open_prec)))
					(firstOrderConstraint (make-order_constraint
											:before_node (get-start-node (partial_plan-plan_nodes part_plan))
											:after_node action))
					(secondOrderConstraint (make-order_constraint
											:before_node action
											:after_node (get-finish-node (partial_plan-plan_nodes part_plan))))
					(order (is-constraint-existing? (make-order_constraint
					            :before_node action
					            :after_node (open_precondition-node open_prec)) (append (list firstOrderConstraint secondOrderConstraint) 
																							(partial_plan-order_constraints part_plan))))
					(actionPreconditions (mapcar #'(lambda(x)(make-open_precondition
                                         :precondition x
                                         :node action))
										(plan_node-preconditions action)))
		            (new_part_plan (make-partial_plan
									:plan_nodes (cons action (partial_plan-plan_nodes part_plan))
									:causal_links (cons causal (partial_plan-causal_links part_plan))
									:order_constraints (append order (list firstOrderConstraint secondOrderConstraint) (partial_plan-order_constraints part_plan))
									:open_precs (append (remove-precondition open_prec 
									        (partial_plan-open_precs part_plan)) actionPreconditions)))
					(consistent_plan (consistent? new_part_plan)))
					
					(cond ((null consistent_plan) (expand-partial-plan-with-new-actions
														   part_plan
														   open_prec
														   (cons new_part_plan open_list)
														   (cdr action_nodes_new)))
						(t (expand-partial-plan-with-new-actions
							   part_plan
							   open_prec
							   (append (make-consistent consistent_plan (list new_part_plan)) open_list)
							   (cdr action_nodes_new))))
			
			))))

(defun make-consistent (conflict_list inconsistent_list)
	(cond ((or (null inconsistent_list) (null conflict_list))())
			(t (append (revised-part-plan1 (car conflict_list) (cdr conflict_list) (car inconsistent_list))
					   (revised-part-plan2 (car conflict_list) (cdr conflict_list) (car inconsistent_list)) 
					   ))))
					
(defun revised-part-plan1 (conflict rem_conflict_list inconsistent_plan)
	(let*((Am (causal_link-plan_node_1 (car conflict)))
			(An (causal_link-plan_node_2 (car conflict)))
			(Ak (cadr conflict))
			(order_constraint (make-order_constraint
								:before_node An
								:after_node Ak))
			(rev_part_plan (make-partial_plan
								:plan_nodes (partial_plan-plan_nodes inconsistent_plan)
								:causal_links (partial_plan-causal_links inconsistent_plan)
								:order_constraints (cons order_constraint (partial_plan-order_constraints inconsistent_plan))
								:open_precs (partial_plan-open_precs inconsistent_plan))))
								
								(cond ((and (not (equal (action-act_name (plan_node-act An)) 'FINISH)) (no-cycles rev_part_plan))
											(cond ((not (consistent? rev_part_plan)) (list rev_part_plan))
													(t (make-consistent rem_conflict_list (list rev_part_plan)))))
										(t ()))))
														
(defun revised-part-plan2 (conflict rem_conflict_list inconsistent_plan)
	(let*((Am (causal_link-plan_node_1 (car conflict)))
			(An (causal_link-plan_node_2 (car conflict)))
			(Ak (cadr conflict))
			(order_constraint (make-order_constraint
								:before_node Ak
								:after_node Am))
			(rev_part_plan (make-partial_plan
								:plan_nodes (partial_plan-plan_nodes inconsistent_plan)
								:causal_links (partial_plan-causal_links inconsistent_plan)
								:order_constraints (cons order_constraint (partial_plan-order_constraints inconsistent_plan))
								:open_precs (partial_plan-open_precs inconsistent_plan))))
								(cond ((and (not (equal (action-act_name (plan_node-act Am)) 'START)) (no-cycles rev_part_plan))
											(cond ((not (consistent? rev_part_plan)) (list rev_part_plan))
													(t (make-consistent rem_conflict_list (list rev_part_plan)))))
										(t ()))))
			
(defun is-constraint-existing? (order_const list_of_order_constraints)
	(cond ((null list_of_order_constraints) (list order_const))
			(t (let*((node1 (order_constraint-before_node order_const))
					(node2 (order_constraint-after_node order_const))
					(before (order_constraint-before_node (car list_of_order_constraints)))
					(after (order_constraint-after_node (car list_of_order_constraints))))
					(cond ((and (equal node1 before) (equal node2 after)) nil)
							(t (is-constraint-existing? order_const (cdr list_of_order_constraints))))))))
			
(defun consistent? (new_part_plan)
; new_part_plan is a structure of type partial_plan
; return true if it is consistent --- that is, the protected
;   preconditions on its causal links are not threatened by any
;   of its actions

	(let*((plan_nodes (partial_plan-plan_nodes new_part_plan))
		(causal_links (partial_plan-causal_links new_part_plan))
		(order_constraints (partial_plan-order_constraints new_part_plan))
		)
		(check-consistent? plan_nodes causal_links order_constraints)
		))
		
(defun check-consistent? (plan_nodes causal_links order_constraints)
	(cond ((null causal_links) ())
		(t (append 
				(check-conflict (car causal_links) plan_nodes order_constraints)
				(check-consistent? plan_nodes (cdr causal_links) order_constraints)))))
				
(defun check-conflict (link plan_nodes order_constraints)
	(cond ((null plan_nodes) ())
			(t (let*((node (car plan_nodes))
					(effects (plan_node-effects node))
					(protected_prop (causal_link-protected_prop link)))
			
				(append (check-deeper effects protected_prop link node order_constraints) 
							(check-conflict link (cdr plan_nodes) order_constraints))))))
								
(defun check-deeper (effects protected_prop link node order_constraints)
	(cond ((null effects) ())
			(t (let*((effect (car effects))
					(sign (give-sign effect))
					(new-literal (make-literal 
									:sign sign
									:pname (literal-pname effect)
									:parameters (literal-parameters effect))))
				(cond ((equal-literals new-literal protected_prop) (append (check-order link node order_constraints)
																			(check-deeper (cdr effects) protected_prop link node order_constraints)))
						(t (check-deeper (cdr effects) protected_prop link node order_constraints)))))))
	
				
																	
(defun check-order (link node order_constraints)
	(cond ((null order_constraints) (list (list link node)))
		(t (let*((node1 (causal_link-plan_node_1 link))
				(node2 (causal_link-plan_node_2 link))
				(constraint (car order_constraints))
				(before_node (order_constraint-before_node constraint))
				(after_node (order_constraint-after_node constraint)))
			(cond ((or (and (equal before_node node) (equal after_node node1)) (and (equal before_node node2) (equal after_node node))) ())
				(t (check-order link node (cdr order_constraints))))))))
					
(defun give-sign (effect)
	(let ((sign (literal-sign effect)))
		(cond ((equal sign 'NEG) nil)
			(t 'NEG))))


(defun literal-is-member-of (literal literal_list)
; literal_list is a list of structures of type literal 
; return T if literal is a member of literal_list
  (cond ((null literal_list) nil)
        ((equal-literals literal (car literal_list))
          t)
        (t (literal-is-member-of literal (cdr literal_list)))))

(defun equal-literals (literal1 literal2)
; literal1 and literal2 are structures of type literal
; return T if they represent the same literal
(and (equal (literal-sign literal1) (literal-sign literal2))
     (equal (literal-pname literal1) (literal-pname literal2))))
     

(defun is-effect-of-action-recipe (literal recipe)
; literal is a structure of type literal 
; recipe is a structure of type action_recipe
; return T if literal is an effect of the action described by recipe
(literal-is-member-of literal (action_recipe-effects recipe)))
         


(defun remove-precondition (prec open_prec_list)
; prec is a structure of type open_precondition
; open_prec_list is a list of structures of type open_precondition
; return open_prec_list after removing prec
(cond ((null open_prec_list) nil)
      ((and (equal-literals 
               (open_precondition-precondition prec)
               (open_precondition-precondition (car open_prec_list)))
            (equal (plan_node-name (open_precondition-node prec))
                   (plan_node-name (open_precondition-node (car open_prec_list)))))
       (cdr open_prec_list))
      (t (cons (car open_prec_list)
               (remove-precondition prec (cdr open_prec_list))))))

(defun get-start-node (nodes)
; nodes is a list of structures of type plan_node
; return the node that is the START node
(cond((null nodes) nil)
     ((equal (action-act_name (plan_node-act (car nodes))) 'START)
        (car nodes))
     (t (get-start-node (cdr nodes)))))

(defun get-finish-node (nodes)
; nodes is a list of structures of type plan_node
; return the node that is the FINISH node
(cond((null nodes) nil)
     ((equal (action-act_name (plan_node-act (car nodes))) 'FINISH)
        (car nodes))
     (t (get-finish-node (cdr nodes)))))


(defun no-cycles (part_plan)
; part_plan is a structure of type partial_plan
; assumes that no order constraint in part_plan places an action
;   before the Start node or after the Finish node
; return true if the order_constraints of part_plan do not cycles
; otherwise return nil
   (check-for-cycles (partial_plan-order_constraints part_plan)
                     (list(list(get-start-node (partial_plan-plan_nodes part_plan))))))

(defun check-for-cycles (constraints check_list)
; this function is used in testing for cycles but nowhere else
; constraints is a list of order_constraints
; check_list is a list of sequences of plan_nodes
; return true if none of the sequences in check_list can be expanded
;   into a cycle using the ordering given in order_constraints and
;   return nil otherwise
   (cond((null check_list) t)
        (t (let((node_list (add-next-node constraints (car check_list))))
              (cond((equal node_list 'CYCLE) nil)
                   (t (check-for-cycles 
                          constraints
                          (append node_list (cdr check_list)))))))))

(defun add-next-node (constraints node_list)
; this function is used in testing for cycles by check-for-cycles
; constraints is a list of structures of type order_constraint
; node_list is an ordered sequence of structures of type plan_node
; return an expanded node_list that contains an additional element
;   as first element of the list, representing a longer ordered sequence
;   of nodes going toward the Finish node as specified by constraints
;   without leading to a cycle in the plan
; return 'CYCLE if a cycle results
   (cond((null constraints) nil)
        ((equal (order_constraint-before_node (car constraints))
                (car node_list))
          (cond ((equal (action-act_name
                           (plan_node-act
                             (order_constraint-after_node
                                (car constraints))))
                        'FINISH)
                  (add-next-node (cdr constraints) node_list))
                ((is-in? (plan_node-name
                           (order_constraint-after_node
                              (car constraints)))
                         node_list)
                 'CYCLE)
                (t (cons
                      (cons (order_constraint-after_node (car constraints))
                            node_list)
                      (add-next-node (cdr constraints) node_list)))))
        (t (add-next-node (cdr constraints) node_list))))

(defun is-in? (node_name node_list)
; this function is used in functions for testing for cycles
; node_name is the name part of a structure of type plan_node
; node_list of a list of structures of type plan_node
; return true if node_name is the name part of an element of node_list
(cond((null node_list) nil)
     ((equal node_name (plan_node-name (car node_list)))
        t)
     (t (is-in? node_name (cdr node_list)))))
                                      
(defun output-results (plan)
; plan is a structure of type partial_plan
; print the nodes, their causal links, and their order constraints
  (princ "Nodes")
  (terpri)
  (output-nodes (partial_plan-plan_nodes plan))
  (terpri)
  (terpri)
  (princ "Order constraints")
  (terpri)
  (output-order-constraints (partial_plan-order_constraints plan))
  (terpri)
  (terpri)
  (princ "Causal links")
  (terpri)
  (output-causal-links (partial_plan-causal_links plan))
  (terpri)
  (terpri)
  (princ "Drawing goes here")
  (terpri)(terpri)(terpri)(terpri)(terpri)(terpri)(terpri)(terpri)
  (terpri)(terpri)(terpri)(terpri)(terpri)(terpri)(terpri)(terpri))


(defun output-nodes (nodes)
; nodes is a list of structures of type plan_node
; print their names
   (cond ((null nodes) t)   
         (t (princ (plan_node-name (car nodes)))
            (princ "   ")
            (princ (action-act_name (plan_node-act (car nodes))))
            (terpri)
            (output-nodes (cdr nodes)))))

(defun output-order-constraints (constraints)
; constraints is a list of structures of type order_constraint
; print the order constraints
   (cond((null constraints) t)
        (t (princ (plan_node-name (order_constraint-before_node (car constraints))))
           (princ "  Before  ")
           (princ (plan_node-name (order_constraint-after_node (car constraints))))
           (terpri)
           (output-order-constraints (cdr constraints)))))

(defun output-causal-links (causal_links)
; causal_links is a list of structures of type causal_link
; print the nodes and the protected propositions
   (cond ((null causal_links) t)
         (t (princ (plan_node-name(causal_link-plan_node_1(car causal_links))))
            (princ " satisfies ")
            (cond((equal 'NEG 
                        (literal-sign
                           (causal_link-protected_prop
                             (car causal_links))))
                    (princ (literal-sign
                             (causal_link-protected_prop(car causal_links))))
                    (princ " ")))
            (princ (literal-pname(causal_link-protected_prop(car causal_links))))
            (cond ((not(null(literal-parameters
                            (causal_link-protected_prop(car causal_links)))))
                     (princ "(")
                     (print-parameters
                         (literal-parameters
                            (causal_link-protected_prop(car causal_links))))
                     (princ ")")))
            (princ " for node ")
            (princ (plan_node-name(causal_link-plan_node_2(car causal_links))))
            (terpri)
            (output-causal-links (cdr causal_links)))))

(defun print-literals(llist)
; llist is a list of literals
; print them
(cond((null llist) (terpri))
     (t (terpri) 
        (print-literal (car llist))
        (print-literals (cdr llist)))))

(defun print-literal (lit)
; lit is a structure of type literal
; print lit
(cond ((equal 'NEG (literal-sign lit))
        (princ (literal-sign lit))
        (princ " ")))
(princ (literal-pname lit))
(cond ((not(null (literal-parameters lit)))
         (princ "(")
         (print-parameters (literal-parameters lit)) 
         (princ ")")))
(terpri))
 

(defun print-parameters (params)
; params is a list of structures of type Constant
; print them
(cond((null params) nil)
     (t (princ (constant-cname (car params)))
        (princ " ")
        (print-parameters (cdr params)))))
		
		
		
