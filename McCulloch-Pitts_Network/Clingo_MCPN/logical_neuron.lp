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


%% Activation Functions
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


%% Forces one output value per neuron
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