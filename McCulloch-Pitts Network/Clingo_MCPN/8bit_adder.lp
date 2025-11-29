%% Use: clingo '.\McCulloch-Pitts Network\Clingo_MCPN\binary_nuumber.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\logical_neuron.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\full_adder_network.lp' '.\McCulloch-Pitts Network\Clingo_MCPN\8bit_adder.lp'


%%% BINARY NUMBERS %%%

%% Holds binary number representations
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


%%% LOGICAL NEURONS %%%

%% Nueron Parameters
% Indexes for 8-bit numbers
index(0..7).

% Possible output values for a logical neuron
outputs(0;1).

% Neuron IDs
neuron_ID(a;b;carry;sum_out;
    xor1;and1;xor2;and2;or1).

% Neuron threshold
threshold(1).

%% Neuron definitions
neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
% neuron(ID, Index, Val) :- outputs(Val), ID = carry, Index = 8.
% neuron(carry, 8, _).

% Layer 1 - Input Layer
neuron_carry(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry, Index = 0, Val = 0.
neuron_input(ID, Index, Val) :- neuron(ID, Index, Val), bit(ID, Index, Val).

% Layers 2-4 - "Hidden" Layers
neuron_carry(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry.
neuron_xor1(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor1.
neuron_and1(ID, Index, Val) :- neuron(ID, Index, Val), ID = and1.
neuron_xor2(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor2.
neuron_and2(ID, Index, Val) :- neuron(ID, Index, Val), ID = and2.
neuron_or1(ID, Index, Val) :- neuron(ID, Index, Val), ID = or1.

% Layer 5 - Output Layer
neuron_sum_out(ID, Index, Val) :- neuron(ID, Index, Val), ID = sum_out.
neuron_carry(ID, Index, Val) :- neuron(ID, Index, _), outputs(Val), ID = carry, Index = 8.

% Only 1 output value per neuron
1 { neuron(ID, Index, Val) : outputs(Val) } 1 :- neuron_ID(ID), index(Index).
1 { neuron(carry, 8, Val) : outputs(Val) } 1


%%% FULL ADDER NETWORK CONNECTIONS %%%
edge(Source_ID, Target_ID, Index, Val) :-
    neuron(Source_ID, Index, Val),
    neuron(Target_ID, Index, _), 
    Source_ID = a, Target_ID = xor1.
%% Graph Edges
% Layer 1 -> 2
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = a,
    neuron(Target_ID, Index, _), Target_ID = xor1.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = a,
    neuron(Target_ID, Index, _), Target_ID = and1.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = b,
    neuron(Target_ID, Index, _), Target_ID = xor1.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = b,
    neuron(Target_ID, Index, _), Target_ID = and1.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = carry,
    neuron(Target_ID, Index, _), Target_ID = xor2.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = carry,
    neuron(Target_ID, Index, _), Target_ID = and2.

% Layer 2 -> 3
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = xor1,
    neuron(Target_ID, Index, _), Target_ID = xor2.
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = xor1,
    neuron(Target_ID, Index, _), Target_ID = and2.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = and1,
    neuron(Target_ID, Index, _), Target_ID = or1.

% Layer 3 -> 4
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = xor2,
    neuron(Target_ID, Index, _), Target_ID = sum_out.

edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = and2,
    neuron(Target_ID, Index, _), Target_ID = or1.

% Layer 4 -> 5
edge(Source_ID, Target_ID, Index, Val) :- 
    neuron(Source_ID, Index, Val), Source_ID = or1,
    neuron(Target_ID, Index1, _), Target_ID = carry, Index1 = Index + 1.


%%% ACTIVATION FUNCTIONS %%%

% neuron(ID, Index, Val)



% sum_bit(e, Index, Val) :- neuron(sum_out, Index, Val).


%% Run activation functions for every edge


% #show sum_out/3.
#show neuron/3.