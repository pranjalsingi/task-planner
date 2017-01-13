;;Pranjal Singi

(defstruct constant cname)

(defstruct action_recipe act preconditions effects)

(defstruct action act_name (parameters nil))

(defstruct literal (sign nil) pname (parameters nil))

(defstruct plan_node name act preconditions effects)

(defstruct causal_link plan_node_1 plan_node_2 protected_prop)

(defstruct partial_plan plan_nodes causal_links order_constraints open_precs)

(defstruct order_constraint before_node after_node)

(defstruct open_precondition precondition node)

(defstruct conflict causal_link node)

