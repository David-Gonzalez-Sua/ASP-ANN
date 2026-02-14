%% To visualize graph:
%% clingo .\Adaptive_Network\Clingo_ANN\ann.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\network_visualizer.pdf'
%%
%% TODO, notes, and ideas for this file:
% Need to add: biases, activation functions, excitation functions, edge weights, neuron values.
% note: Values for the neurons in terms of excitation and activation functions should go in the definitions for the instance
% IDEA: Send layer size parameters to Python, treat the values and weights as vectors discontected from the neurons and edges
%       This would make it less clear that each neuron has its own value and each edge its own weight.
%       Unsure about the effect on performance.
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

% input_size(3).
% hidden_size(5).
% num_hidden_layers(2).
% output_size(2).

input_size(2).
hidden_size(3).
num_hidden_layers(2).
output_size(1).

%%% Network Structure %%%
% edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight) :-
%     neuron(_, Source_Layer, Source_Index, _, _),
%     neuron(_, Target_Layer, Target_Index, _, _),
%     Target_Layer = Source_Layer + 1,
%     Weight = @random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index).  % Passing in args allows for unique values.

edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight) :-
    neuron(_, Source_Layer, Source_Index),
    neuron(_, Target_Layer, Target_Index),
    Target_Layer = Source_Layer + 1,
    Weight = @random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index).  % Passing in args allows for unique values.

%%% Neuron Definitions %%%
neuron(Type, Layer, Index) :- 
    Type = input, 
    input_size(I), 
    Layer = 1, 
    Index = 1..I.

neuron(Type, Layer, Index) :- 
    Type = hidden, 
    hidden_size(I), 
    num_hidden_layers(H),  
    Layer = 2..H + 1, 
    Index = 1..I.

neuron(Type, Layer, Index) :- 
    Type = output, 
    output_size(I), 
    num_hidden_layers(N),
    Layer = N + 2,
    Index = 1..I.

neuron(Type, Layer, Index) :-
    Type = bias,
    num_hidden_layers(H),
    Layer = 1..H + 1,
    Index = 0.

% Use random input values
neuron(input, 1, Index, Value) :-
    neuron(input, 1, Index),
    Value = @random_value(1, Index).  % Passing in args allows for unique values.

% Set bias neurons
neuron(bias, Layer, 0, -1) :-
% neuron(bias, Layer, 0, -1000000) :-
    neuron(bias, Layer, 0).

% Excitation function
neuron(Type, Layer, Index, Value) :-
    neuron(Type, Layer, Index),
    Layer > 1,
    % Source_Layer = Layer - 1,
    % S = #sum { (Source_Value*Weight)/1000000 : 
    %         neuron(Source_Type, Source_Layer, Source_Index), 
    %         neuron(Source_Type, Source_Layer, Source_Index, Source_Value),
    %         edge(Source_Layer, Source_Index, Layer, Index, Weight) },
    % S = #sum { (Source_Value*Weight)/1000000: 
    %         Source_Layer = Layer - 1,
    %         edge(Source_Layer, Source_Index, Layer, Index, Weight),
    %         neuron(_, Source_Layer, Source_Index, Source_Value) },
    % Value = S.
    % Value = 1.
    Value = #sum { @multiply(Source_Value, Weight) : 
    % Value = #sum { (Source_Value*Weight)/1000000: 
            edge(Layer - 1, Source_Index, Layer, Index, Weight),
            neuron(_, Layer - 1, Source_Index, Source_Value) }.
    
    
            % Source_Layer = Layer - 1,
            % edge(Source_Layer, Source_Index, Layer, Index, Weight),
            % neuron(_, Source_Layer, Source_Index, Source_Value) }.

% % BIAS NEURON for hidden layers
% neuron(Type, Layer, Index, -1000000) :-
%     Type = bias,
%     hidden_size(I), 
%     num_hidden_layers(N),  
%     Layer = 2..N + 1,
%     Index = I + 1.

% neuron(Type, 1, Index, Val) :-  % Initializes inupt neurons with random values    TEMPORARY
%     neuron(Type, 1, Index),
%     Type = input,
%     Val = @random_value(1, Index).  % Passing in args allows for unique values.

% neuron(Type, Layer, Index, Val) :-  % Excitation of first hidden layer
%     neuron(Type, Layer, Index),
%     Type != input,
%     excitation(_, _, Layer, Index, Val).

% % neuron(Type, Layer, Index, Exc) :-  % Excitation of every other hidden layer and output layer
% %     neuron(Type, Layer, Index),
% %     hidden_size(I),
% %     Layer > 2,
% %     Source_Layer = Layer - 1,
% %     Source_Index = 1..I,
% %     Exc = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, V), edge(Source_Layer, Source_Index, Layer, Index, W) }.  % Excitation function

% % Input -> Hidden excitation
% excitation(Source_Layer, Source_Size, Target_Layer, Target_Index, Exc) :-
%     neuron(_, Target_Layer, Target_Index),
%     input_size(Source_Size),
%     hidden_size(I),
%     Target_Layer = 2,
%     Source_Layer = 1,
%     Source_Index = 1..Source_Size + 1,
%     Exc = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, V), edge(Source_Layer, Source_Index, Target_Layer, Target_Index, W) }.

% % Hidden -> Hidden/Output excitation
% excitation(Source_Layer, Source_Size, Target_Layer, Target_Index, Exc) :-
%     neuron(_, Target_Layer, Target_Index),
%     num_hidden_layers(N),
%     hidden_size(Source_Size),
%     Target_Layer = 3..N + 2,
%     Source_Layer = Target_Layer - 1,
%     Source_Index = 1..Source_Size + 1,
%     Exc = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, V), edge(Source_Layer, Source_Index, Target_Layer, Target_Index, W) }.

% Hidden -> Output excitation
% excitation(Source_Layer, Source_Size, Target_Layer, Target_Index, Exc) :-
%     neuron(_, Target_Layer, Target_Index),
%     num_hidden_layers(N),
%     hidden_size(HidSize),
%     output_size(OutSize),
%     Target_Layer = N + 2,
%     Target_Index = 1..OutSize,
%     Source_Layer = Target_Layer - 1,
%     Source_Index = 1..HidSize,
%     Exc = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, V), edge(Source_Layer, Source_Index, Layer, Index, W) }.

% neuron(Type, Layer, Index, Val) :-
%     neuron(Type, Layer, Index),
%     Type != input,
%     Source_Layer = Layer - 1,
%     Source_Index = 1..I,
%     S = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, _, V), edge(Source_Layer, Source_Index, Layer, Index, W) },
%     Val = S + Bias.  % Excitation function

% excitation(Layer, Index, Val) :-
%     neuron(_, Layer, Index, Val, Bias),
%     hidden_size(I),
%     Source_Layer = Layer - 1,
%     Source_Index = 1..I,
%     S = #sum { ((V * W) / 1000000) : neuron(_, Source_Layer, Source_Index, _, V), edge(Source_Layer, Source_Index, Layer, Index, W) },
%     Val = S + Bias.

% neuron(Type, Layer, Index, Val, Bias) :- 
%     Type = input, 
%     input_size(I), 
%     Layer = 1, 
%     Index = 1..I,
%     Val = @random_value(Layer, Index),  % Passing in args allows for unique values.
%     Bias = 0.

% neuron(Type, Layer, Index, Val) :- 
%     Type = hidden,
%     hidden_size(I), 
%     num_hidden_layers(N),  
%     Layer = 2..N + 1, 
%     Index = 1..I,
%     Val = @random_value(Layer, Index).  % Passing in args allows for unique values

% neuron(Type, Layer, Index, Val) :- 
%     Type = output, 
%     output_size(I), 
%     num_hidden_layers(N),
%     Layer = N + 2,
%     Index = 1..I,
%     Val = @random_value(Layer, Index).  % Passing in args allows for unique values

% neuron(Type, Layer, Index, Val, Bias) :-
%     neuron(Type, Layer, Index),
%     Type = input,
%     Val = excitation(Layer, Index, Val),
%     Bias = 0.

% neuron(Type, Layer, Index, Val, Bias) :-
%     neuron(Type, Layer, Index),
%     Type = input,
%     excitation(Layer, Index, Val),
%     Bias = 0.

% neuron(Type, Layer, Index, Val, Bias) :- 
%     Type = hidden,
%     hidden_size(I), 
%     num_hidden_layers(N),  
%     Layer = 2..N + 1, 
%     Index = 1..I,
%     excitation(Layer, Index, Val),
%     % Val = 0,
%     Bias = 0.

% neuron(Type, Layer, Index, Val, Bias) :- 
%     Type = output, 
%     output_size(I), 
%     num_hidden_layers(N),
%     Layer = N + 2,
%     Index = 1..I,
%     excitation(Layer, Index, Val),
%     % Val = 0,
%     Bias = 0.

% Forces on neuron per node, and can be used in other functions
% 1 { neuron(Type, Layer, Index) } 1 :- 
%     Type = input,


% neuron_value(Layer, Index, Val) :-
%     neuron(_, Layer, Index),
%     Val = random_value().
%neuron(ID, Index, Val) :- neuron_ID(ID), index(Index), outputs(Val).
%neuron(ID, Index, Val) :- carry_index(Index), outputs(Val), ID = carry.


%% Excitation Functions

%% Activation Functions


% #show neuron/3.
#show neuron/4.
% #show neuron/5.
#show edge/5.
% #show excitation/3.
% #show val/3.


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

def random_value(Layer, Index):
    # Returns a scaled integer value between 0 and 1 with 6 decimal places. (python stores 17ish though)
    val = random.uniform(0, 10)
    # return clingo.String(f"{val:.6f}")
    # return clingo.Number(int(val * 1e6))
    return clingo.String(str(val))

def random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index):
    # Generate a single random float as a scaled integer with 6 decimal places.
    val = random.uniform(-0.5, 0.5)
    # return clingo.Number(int(val * 1e6))
    return clingo.String(str(val))

def multiply(x, y):
    xfloat = float(x.string)
    yfloat = float(y.string)
    mult = xfloat * yfloat
    return clingo.String(str(mult))

#end.