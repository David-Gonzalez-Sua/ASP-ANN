%% Single logical neuron implementation in a McCulloch-Pitts network


%%% Logical Nueron %%%

%% Nueron Parameters
% Indexes for 8-bit numbers
index(0..7).
index_carry(0..8).

% Possible output values for a logical neuron
outputs(0;1).

% Neuron IDs
% No carry ID needed. This is handled by the neuron definitions since carry neurons hold one extra index.
% neuron_ID(a;b;carry;sum_out;
%     xor1;and1;xor2;and2;or1).
neuron_ID(a;b;sum_out;xor1;and1;xor2;and2;or1).

% Neuron threshold
threshold(1).

%% Neuron definitions
neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
neuron(ID, Index, Val) :- index_carry(Index), outputs(Val), ID = carry.

% Forces one fact of type neuron for each actual neuron
neuron(ID, Index, Val) :- neuron_input(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_carry(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_xor1(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_and1(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_xor2(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_and2(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_or1(ID, Index, Val).
neuron(ID, Index, Val) :- neuron_sum_out(ID, Index, Val).

% neuron(ID, Index, Val) :- bit
% neuron(ID, Index, Val) :- outputs(Val), ID = carry, Index = 8.
% neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val), Index <= 7, ID != carry.
% neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val), ID = carry.

% % Layer 1 - Input Layer
% neuron_carry(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry, Index = 0, Val = 0.
% neuron_input(ID, Index, Val) :- neuron(ID, Index, Val), bit(ID, Index, Val).

% % Layers 2-4 - "Hidden" Layers
% neuron_carry(ID, Index, Val) :- neuron(ID, Index, Val), ID = carry.
% neuron_xor1(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor1.
% neuron_and1(ID, Index, Val) :- neuron(ID, Index, Val), ID = and1.
% neuron_xor2(ID, Index, Val) :- neuron(ID, Index, Val), ID = xor2.
% neuron_and2(ID, Index, Val) :- neuron(ID, Index, Val), ID = and2.
% neuron_or1(ID, Index, Val) :- neuron(ID, Index, Val), ID = or1.

% % Layer 5 - Output Layer
% neuron_sum_out(ID, Index, Val) :- neuron(ID, Index, Val), ID = sum_out.
% neuron_carry(ID, Index, Val) :- neuron(ID, Index, _), outputs(Val), ID = carry, Index = 8.

% Layer 1 - Input Layer
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 0, Val = 0.
1 { neuron_input(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- bit(ID, Index, Val).

% Layers 2-4 - "Hidden" Layers
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = carry.
1 { neuron_xor1(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor1.
1 { neuron_and1(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and1.
1 { neuron_xor2(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor2.
1 { neuron_and2(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and2.
1 { neuron_or1(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = or1.

% Layer 5 - Output Layer
1 { neuron_sum_out(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = sum_out.
1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 8.

% Only 1 output value per neuron
% 1 { neuron(ID, Index, Val) : outputs(Val) } 1 :- neuron_ID(ID), index(Index).
% { neuron(ID, Index, Val) : outputs(Val) } 1 :- neuron_ID(ID).
% { neuron(ID, Index, Val) : outputs(Val) } 1 :- index(Index).

% #show neuron/3.
% #show neuron_input/3.
% #show neuron_carry/3.
% #show neuron_xor1/3.
% #show neuron_sum_out/3.


% function_xor(A, B, E) :- E = (A + B) mod 2.
% activate_xor(A, B, Y) :-
%     function_xor(A, B, E), E >= Theta,
%     Theta = 1, Y = 1.
% activate_xor(A, B, Y) :-
%     function_xor(A, B, E), E < Theta,
%     Theta = 1, Y = 0.

% function_and(A, B, E) :- E = A * B.
% activate_and(A, B, Y) :-
%     function_and(A, B, E), E >= Theta, 
%     Theta = 1, Y = 1.
% activate_and(A, B, Y) :-
%     function_and(A, B, E), E < Theta, 
%     Theta = 1, Y = 0.

% function_or(A, B, E) :- E = A + B.
% activate_or(A, B, Y) :-
%     function_or(A, B, E), E >= Theta,
%     Theta = 1, Y = 1.
% activate_or(A, B, Y) :-
%     function_or(A, B, E), E < Theta,
%     Theta = 1, Y = 0.