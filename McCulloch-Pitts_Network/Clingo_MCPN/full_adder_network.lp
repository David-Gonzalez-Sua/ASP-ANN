%%% FULL ADDER NETWORK CONNECTIONS %%%


%% Graph Edges
% Layer 1 -> 2
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_input(Source_ID, Index, Val), Source_ID = a,
    neuron_xor(Target_ID, Index, _), Target_ID = xor1.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_input(Source_ID, Index, Val), Source_ID = a,
    neuron_and(Target_ID, Index, _), Target_ID = and1.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_input(Source_ID, Index, Val), Source_ID = b,
    neuron_xor(Target_ID, Index, _), Target_ID = xor1.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_input(Source_ID, Index, Val), Source_ID = b,
    neuron_and(Target_ID, Index, _), Target_ID = and1.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_carry(Source_ID, Index, Val), Source_ID = carry,
    neuron_xor(Target_ID, Index, _), Target_ID = xor2.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_carry(Source_ID, Index, Val), Source_ID = carry,
    neuron_and(Target_ID, Index, _), Target_ID = and2.

% Layer 2 -> 3
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_xor(Source_ID, Index, Val), Source_ID = xor1,
    neuron_xor(Target_ID, Index, _), Target_ID = xor2.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_xor(Source_ID, Index, Val), Source_ID = xor1,
    neuron_and(Target_ID, Index, _), Target_ID = and2.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_and(Source_ID, Index, Val), Source_ID = and1,
    neuron_or(Target_ID, Index, _), Target_ID = or1.

% Layer 3 -> 4, 5
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_xor(Source_ID, Index, Val), Source_ID = xor2,
    neuron_output(Target_ID, Index, _), Target_ID = output.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron_and(Source_ID, Index, Val), Source_ID = and2,
    neuron_or(Target_ID, Index, _), Target_ID = or1.

% Layer 4 -> 5
edge(Source_ID, Target_ID, Target_Index, Val) :- 
    neuron_or(Source_ID, Source_Index, Val), Source_ID = or1,
    neuron_carry(Target_ID, Target_Index, _), Target_ID = carry, 
    Target_Index = Source_Index + 1.


%% Neuron activations
% Activates every neuron type using input from edges
neuron_xor(ID, Index, Val) :-
    edge(Source1_ID, ID, Index, Input1), 
    edge(Source2_ID, ID, Index, Input2), 
    Source1_ID != Source2_ID, 
    act_fun(Input1, Input2, Val, xor).

neuron_and(ID, Index, Val) :-
    edge(Source1_ID, ID, Index, Input1),
    edge(Source2_ID, ID, Index, Input2),
    Source1_ID != Source2_ID,
    act_fun(Input1, Input2, Val, and).

neuron_or(ID, Index, Val) :-
    edge(Source1_ID, ID, Index, Input1),
    edge(Source2_ID, ID, Index, Input2),
    Source1_ID != Source2_ID,
    act_fun(Input1, Input2, Val, or).

neuron_output(ID, Index, Val) :-
    edge(Source_ID, ID, Index, Input),
    act_fun(Input, Val, output).

neuron_carry(ID, Index, Val) :-
    edge(Source_ID, ID, Index, Input),
    act_fun(Input, Val, carry),
    Index > 0.