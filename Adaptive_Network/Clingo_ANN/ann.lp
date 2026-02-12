%% TODO, notes, and ideas for this file:
% Need to add: biases, activation functions, excitation functions, edge weights, neuron values.
% 2 options for real number value representation:
%    1. represent value as a scaled integer in Clingo (e.g. 123456 = 0.123456 * 1,000,000). 
%       Do the dot product in clingo (dividing by the rescale factor in each term)
%       Use ReLU as the activation function (max(0, x))
%       Pros: Fully self-contained in Clingo, no need to parse strings back to floats in Python.
%       Cons: Limited to ReLU activation function, and potential issues with precision and scaling.
%    2. represent value as a string in Clingo (e.g. "0.123456") with 17 decimal places (python's default for floats).
%       Do the dot product in Python (parsing the string back to a float)
%       Now I can use any activation function (ReLU, sigmoid, etc.)
%       Pros: More flexible with activation functions, and can leverage Python's handling of floats.
%       Cons: This is less elegant or self-contained. Could introduce performance overhead.

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
    neuron(_, Source_Layer, Source_Index, _),
    neuron(_, Target_Layer, Target_Index, _),
    Target_Layer = Source_Layer + 1.

%%% Nueron Parameters %%%
% TODO: type, value, bias, name

%neuron_type(input;hidden;output).
%layer().
%index().

%%% Neuron Definitions %%%
neuron(Type, Layer, Index, Val) :- 
    Type = input, 
    input_size(I), 
    Layer = 1, 
    Index = 1..I,
    Val = @random_value().

neuron(Type, Layer, Index, Val) :- 
    Type = hidden,
    hidden_size(I), 
    num_hidden_layers(N),  
    Layer = 2..N + 1, 
    Index = 1..I,
    Val = @random_value().

neuron(Type, Layer, Index, Val) :- 
    Type = output, 
    output_size(I), 
    num_hidden_layers(N),
    Layer = N + 2,
    Index = 1..I,
    Val = @random_value().

% neuron_value(Layer, Index, Val) :-
%     neuron(_, Layer, Index),
%     Val = random_value().
%neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
%neuron(ID, Index, Val) :- carry_index(Index), outputs(Val), ID = carry.


%% Excitation Functions

%% Activation Functions


#show neuron/4.
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

#script (python)
import clingo
import random

def random_value():
    # Returns a scaled integer value between 0 and 1 with 6 decimal places. (python stores 17ish though)
    val = random.random()
    # return clingo.String(f"{val:.6f}")
    return clingo.Number(int(val * 1e6))

#end.