;; Pranjal Singi

(setf act_cook (make-action
               :act_name 'Cook))
(setf act_wrap (make-action
               :act_name 'Wrap))
(setf act_carry (make-action
               :act_name 'Carry))
(setf act_dolly (make-action
               :act_name 'Dolly))
(setf act_BuyDolly (make-action
               :act_name 'BuyDolly))
(setf act_ReadDollyManual (make-action
               :act_name 'ReadDollyManual))

(setf prop_CleanHands
                (make-literal
                  :pname 'CleanHands))
(setf prop_Not_CleanHands
                (make-literal
                  :sign 'NEG
                  :pname 'CleanHands))
(setf prop_Dinner
                (make-literal
                  :pname 'Dinner))

(setf prop_Quiet
                (make-literal
                  :pname 'Quiet))
(setf prop_Not_Quiet
                (make-literal
                  :sign 'NEG
                  :pname 'QUIET))

(setf prop_Present
                (make-literal
                  :pname 'Present))

(setf prop_Garbage
                (make-literal
                  :pname 'Garbage))
(setf prop_Not_Garbage
                (make-literal
                  :sign 'NEG
                  :pname 'Garbage))

(setf prop_Have_Dolly
                (make-literal
                  :pname 'Have_Dolly))

(setf prop_Can_Operate_Dolly
                (make-literal
                  :pname 'Can_Operate_Dolly))

(setf prop_Have_Dolly_Manual
                (make-literal
                   :pname 'Have_Dolly_Manual))

(setf prop_Have_Money
                (make-literal
                   :pname 'Have_Money))

(setf recipe_Cook (make-action_recipe
                  :act act_cook
                  :preconditions
                     (list prop_CleanHands)
                  :effects
                     (list prop_Dinner)))

(setf recipe_Wrap (make-action_recipe
                   :act act_wrap
                   :preconditions
                     (list prop_Quiet)
                   :effects
                     (list prop_Present)))

(setf recipe_Carry (make-action_recipe
                    :act act_Carry
                    :preconditions nil
                    :effects
                      (list prop_Not_Garbage
                            prop_Not_CleanHands)))

(setf recipe_Dolly (make-action_recipe
                     :act act_Dolly
                     :preconditions nil
                     :effects
                       (list prop_Not_Garbage
                             prop_Not_Quiet)))
(setf recipe_Dolly2 (make-action_recipe
                     :act act_Dolly
                     :preconditions 
                        (list prop_Have_Dolly
                              prop_Can_Operate_Dolly)
                     :effects
                       (list prop_Not_Garbage
                             prop_Not_Quiet)))

(setf recipe_BuyDolly (make-action_recipe
                      :act act_BuyDolly
                      :preconditions (list prop_Have_Money)
                      :effects
                        (list prop_Have_Dolly)))

(setf recipe_ReadDollyManual (make-action_recipe
                      :act act_ReadDollyManual
                      :preconditions (list prop_Have_Dolly_Manual)
                      :effects
                        (list prop_Can_Operate_Dolly)))

(setf act_Eat (make-action
               :act_name 'Eat))

(setf act_Catch (make-action
               :act_name 'Catch))

(setf prop_Ready
                (make-literal
                  :pname 'Ready))

(setf prop_Hands_Free
                (make-literal
                  :pname 'Hands_Free))

(setf prop_Has_Ball
                (make-literal
                  :pname 'Has_Ball))

(setf prop_Stomach_Full
                (make-literal
                  :pname 'Stomach_Full))

(setf prop_Not_Ready
                (make-literal
                  :sign 'NEG
                  :pname 'Ready))

(setf prop_Not_Hands_Free
                (make-literal
                  :sign 'NEG
                  :pname 'Hands_Free))


(setf recipe_Catch (make-action_recipe
                     :act act_Catch
                     :preconditions (list prop_Ready)
                     :effects 
                         (list prop_Has_Ball
                               prop_Not_Hands_Free)))

(setf recipe_Eat (make-action_recipe
                      :act act_Eat
                      :preconditions (list prop_Hands_Free)
                      :effects 
                         (list prop_Not_Ready 
                               prop_Stomach_Full)))


(setf act_A (make-action
               :act_name 'A))
(setf act_B (make-action
               :act_name 'B))
(setf act_C (make-action
               :act_name 'C))
(setf act_D (make-action
               :act_name 'D))
(setf act_E (make-action
               :act_name 'E))
(setf act_F (make-action
               :act_name 'F))
(setf act_Play (make-action
               :act_name 'Play))
(setf prop_P1
                (make-literal
                  :pname 'P1))
(setf prop_P2
                (make-literal
                  :pname 'P2))
(setf prop_P3
                (make-literal
                  :pname 'P3))
(setf prop_P4
                (make-literal
                  :pname 'P4))
(setf prop_P5
                (make-literal
                  :pname 'P5))
(setf prop_P6
                (make-literal
                  :pname 'P6))
(setf prop_Q1
                (make-literal
                  :pname 'Q1))
(setf prop_Q2
                (make-literal
                  :pname 'Q2))
(setf prop_Not_P2
                (make-literal
                  :sign 'NEG
                  :pname 'P2))
(setf prop_Not_P3
                (make-literal
                  :sign 'NEG
                  :pname 'P3))
(setf recipe_A (make-action_recipe
                     :act act_A
                     :preconditions (list prop_Q1)
                     :effects 
                         (list prop_P1)))
(setf recipe_B (make-action_recipe
                     :act act_B
                     :preconditions (list prop_P1)
                     :effects 
                         (list prop_P2)))
(setf recipe_C (make-action_recipe
                     :act act_C
                     :preconditions (list prop_P2)
                     :effects 
                         (list prop_P3)))
(setf recipe_D (make-action_recipe
                     :act act_D
                     :preconditions (list prop_P3)
                     :effects 
                         (list prop_P4)))
(setf recipe_E (make-action_recipe
                     :act act_E
                     :preconditions (list prop_Q2)
                     :effects 
                         (list prop_P5)))
(setf recipe_F (make-action_recipe
                     :act act_F
                     :preconditions nil
                     :effects 
                         (list prop_P6)))
(setf recipe_Play (make-action_recipe
                     :act act_Play
                     :preconditions (list prop_P6)
                     :effects 
                         (list prop_Q2 prop_Not_P2 prop_Not_P3)))
