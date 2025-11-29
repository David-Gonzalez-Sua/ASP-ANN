%% Single logical neuron implementation in a McCulloch-Pitts network


%%% Logical Nueron %%%

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
neuron(ID, Index, Val) :- outputs(Val), ID = carry, Index = 8.

% Layer 1 - Input Layer
neuron_carry(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry, Index = 0, Val = 0.
neuron_input(ID, Index, Val) :- neuron(ID, Inedx, Val), bit(ID, Index, Val).

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