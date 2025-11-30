%% Use: clingo '.\McCulloch-Pitts Network\Clingo_MCPN\binary_nuumber.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\logical_neuron.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\full_adder_network.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\8bit_adder.lp'
%% Use: clingo '.\McCulloch-Pitts Network\Clingo_MCPN\8bit_adder.lp'
%% Use: clingo '.\McCulloch-Pitts Network\Clingo_MCPN\8bit_adder.lp' | python '.\McCulloch-Pitts Network\Clingo_MCPN\graph_visualizer.py' | dot -T pdf -o '.\McCulloch-Pitts Network\Clingo_MCPN\network_visualizer.pdf'


%%% BINARY NUMBERS %%%

%% Holds binary number representations of testing parameters
% Binary 5
bit(a, 0, 1).
bit(a, 1, 0).
bit(a, 2, 1).
bit(a, 3, 0).
bit(a, 4, 0).
bit(a, 5, 0).
bit(a, 6, 0).
bit(a, 7, 0).

% Binary 35
bit(b, 0, 1).
bit(b, 1, 1).
bit(b, 2, 0).
bit(b, 3, 0).
bit(b, 4, 0).
bit(b, 5, 1).
bit(b, 6, 0).
bit(b, 7, 0).

% Expected result: Binary 40
% bit(e, 0, 0).
% bit(e, 1, 0).
% bit(e, 2, 0).
% bit(e, 3, 1).
% bit(e, 4, 0).
% bit(e, 5, 1).
% bit(e, 6, 0).
% bit(e, 7, 0).


%%% Logical Nueron %%%

%% Nueron Parameters
% Indexes for 8-bit numbers
index(0..7).
carry_index(0..8).

% Possible output values for a logical neuron
outputs(0;1).

% Neuron IDs
neuron_ID(a;b;output;xor1;and1;xor2;and2;or1).

% Neuron threshold
threshold(1).

%% Neuron definitions
neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
neuron(ID, Index, Val) :- carry_index(Index), outputs(Val), ID = carry.

% Forces one fact of type neuron for each actual neuron - DOESNT WORK i think
% neuron(ID, Index, Val) :- neuron_input(ID, Index, Val).
% neuron(ID, Index, Val) :- neuron_carry(ID, Index, Val).
% neuron(ID, Index, Val) :- neuron_xor(ID, Index, Val).
% neuron(ID, Index, Val) :- neuron_and(ID, Index, Val).
% neuron(ID, Index, Val) :- neuron_or(ID, Index, Val).
% neuron(ID, Index, Val) :- neuron_output(ID, Index, Val).

% Forces one value per neuron
% Layer 1 - Input Layer
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 0, Val = 0.
1 { neuron_input(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- bit(ID, Index, Val).

% Layers 2-4 - "Hidden" Layers
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = carry.
1 { neuron_xor(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor1.
1 { neuron_and(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and1.
1 { neuron_xor(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor2.
1 { neuron_and(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and2.
1 { neuron_or(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = or1.

% Layer 5 - Output Layer
1 { neuron_output(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = output.
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 8.


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
% edge(Source_ID, Target_ID, Index, Val) :- 
edge(Source_ID, Target_ID, Target_Index, Val) :- 
    neuron_or(Source_ID, Source_Index, Val), Source_ID = or1,
    neuron_carry(Target_ID, Target_Index, _), Target_ID = carry, 
    Target_Index = Source_Index + 1.


%%% ACTIVATION FUNCTIONS %%%

% 2-var excitation functions
exc_fun(A, B, Exc, Theta, Type) :- 
    outputs(A), outputs(B), 
    Type = xor, Theta = 1, 
    Exc = (A + B) - (2 * A * B).

exc_fun(A, B, Exc, Theta, Type) :- 
    outputs(A), outputs(B), 
    Type = and, Theta = 1, 
    Exc = A * B.

exc_fun(A, B, Exc, Theta, Type) :- 
    outputs(A), outputs(B), 
    Type = or, Theta = 1, 
    Exc = A + B.

% 2-var activation function
act_fun(A, B, Output, Type) :-
    exc_fun(A, B, Exc, Theta, Type),
    Exc >= Theta, Output = 1.
act_fun(A, B, Output, Type) :-
    exc_fun(A, B, Exc, Theta, Type),
    Exc < Theta, Output = 0.

% 1-var excitation functions
exc_fun(A, Exc, carry) :- outputs(A), Exc = A.
exc_fun(A, Exc, output) :- outputs(A), Exc = A.

% 1-var activation function
act_fun(A, Output, Type) :-
    exc_fun(A, Exc, Type),
    Output = Exc.

%% Neuron Activations
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


%%% SHOW SUM IN A READABLE FORMAT %%%

%% Show answer in binary
sum_bit(Index, Val) :- neuron_output(output, Index, Val).
binary_sum(B7, B6, B5, B4, B3, B2, B1, B0) :- 
    sum_bit(7, B7), sum_bit(6, B6),
    sum_bit(5, B5), sum_bit(4, B4),
    sum_bit(3, B3), sum_bit(2, B2),
    sum_bit(1, B1), sum_bit(0, B0).

#show sum_bit/2.
#show binary_sum/8.

%% Show edges to create graph visualization
% #show edge/4.


% #show neuron_or1/3.
% or1(Index, Val) :- neuron(or1, Index, Val).
% #show or1/2.
% edge_test(or1, carry, Carry_Index, Val) :- edge(or1, carry, Carry_Index, Val).
% edge_test(carry, xor2, 0, Val) :- edge(carry, xor2, 0, Val).
% #show edge_test/4.

% xor_test(A, B, Exc) :- exc_fun(A, B, Exc, 1, xor).
% #show xor_test/3.
