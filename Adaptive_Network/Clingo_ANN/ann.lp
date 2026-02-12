%%% Network Parameters %%%
% # Set network parameters
% input_size(784).
% hidden_size(128).
% num_hidden_layers(2).
% output_size(10).

input_size(3).
hidden_size(5).
num_hidden_layers(2).
output_size(2).

%%% Network Structure %%%
edge(Source_Layer, Source_Index, Target_Layer, Target_Index) :-
    neuron(_, Source_Layer, Source_Index),
    neuron(_, Target_Layer, Target_Index),
    Target_Layer = Source_Layer + 1.

%%% Nueron Parameters %%%
% TODO: type, value, bias, name

%neuron_type(input;hidden;output).
%layer().
%index().

%%% Neuron Definitions %%%
neuron(Type, Layer, Index) :- 
    Type = input, 
    input_size(I), 
    Layer = 1, 
    Index = 1..I.

neuron(Type, Layer, Index) :- 
    Type = hidden,
    hidden_size(I), 
    num_hidden_layers(N),  
    Layer = 2..N + 1, 
    Index = 1..I.

neuron(Type, Layer, Index) :- 
    Type = output, 
    output_size(I), 
    num_hidden_layers(N),
    Layer = N + 2,
    Index = 1..I.

%neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
%neuron(ID, Index, Val) :- carry_index(Index), outputs(Val), ID = carry.


%% Activation Functions

%% Excitation Functions


#show neuron/3.
#show edge/4.



%% Forces one output value per neuron
% Layer 1 - Input Layer
%1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 0, Val = 0.
%1 { neuron_input(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- bit(ID, Index, Val).

% Layers 2-4 - "Hidden" Layers
%1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = carry.
%1 { neuron_xor(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor1.
%1 { neuron_and(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and1.
%1 { neuron_xor(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = xor2.
%1 { neuron_and(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = and2.
%1 { neuron_or(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = or1.

% Layer 5 - Output Layer
%1 { neuron_output(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- index(Index), ID = output.
%1 { neuron_carry(ID, Index, Val) : neuron(ID, Index, Val) } 1 :- ID = carry, Index = 8.