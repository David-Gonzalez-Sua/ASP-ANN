%% Single logical neuron implementation in a McCulloch-Pitts network


%% Indexes for 8-bit numbers
index(0..7).

%% Possible output values for a logical neuron
outputs(0;1).

%% Neuron IDs
neuron_ID(a;b;carry_in;sum_out;carry_out).
neuron_ID(xor1;and1;xor2;and2;or1).

%% Neuron threshold
threshold(1).

%% Neuron definitions
% Input neurons
neuron_input(ID, Index, Val) :- bit(ID, Index, Val).
neuron_carry_in(carry_in, 0, 0).

neuron_xor1(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor1.
neuron_and1(ID, Index, Val) :- neuron(ID, Index, Val), ID = and1.
neuron_xor2(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor2.
neuron_and2(ID, Index, Val) :- neuron(ID, Index, Val), ID = and2.
neuron_or1(ID, Index, Val) :- neuron(ID, Index, Val), ID = or1.
neuron_sum_out(ID, Index, Val) :- neuron(ID, Index, Val), ID = sum_out.
neuron_carry_in(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry_out.

1 { neuron(ID, Index, Val) : outputs(Val) } 1 :- neuron_ID(ID), index(Index).


%% Full Adder Network Connections
% Layer 1
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = a, Output_ID = xor1.
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = a, Output_ID = and1.

edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = b, Output_ID = xor1.
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = b, Output_ID = and1.

edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = carry_in, Output_ID = xor2.
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = carry_in, Output_ID = and2.

% Layer 2
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = xor1, Output_ID = xor2.
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = xor1, Output_ID = and2.

edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = and1, Output_ID = or1.

% Layer 3
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = xor2, Output_ID = sum_out.
edge(Input_ID, Output_ID, Index, Val) :- index(Index), outputs(Val), Input_ID = and2, Output_ID = or1.

% Layer 4
edge(Input_ID, Output_ID, Index, Val) :- Index = Index, outputs(Val), Input_ID = or1, Output_ID = carry_in.

