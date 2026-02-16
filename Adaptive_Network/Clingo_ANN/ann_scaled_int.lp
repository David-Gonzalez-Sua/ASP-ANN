%% To visualize graph:
%% clingo .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\network_visualizer.pdf'
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
edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight) :-
    neuron(_, Source_Layer, Source_Index),
    neuron(_, Target_Layer, Target_Index),
    Target_Layer = Source_Layer + 1,
    % Weight = @random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index).  % Passing in args allows for unique values.
    Weight = 5000.  % 0.5 * 1e4
    % Weight = 500000.  % 0.5 * 1e6

%%% Neuron Definitions %%%

% Input
neuron(Type, Layer, Index) :- 
    Type = input, 
    input_size(I), 
    Layer = 1, 
    Index = 1..I.

% Hidden
neuron(Type, Layer, Index) :- 
    Type = hidden, 
    hidden_size(I), 
    num_hidden_layers(H),  
    Layer = 2..H + 1, 
    Index = 1..I.

% Output
neuron(Type, Layer, Index) :- 
    Type = output, 
    output_size(I), 
    num_hidden_layers(N),
    Layer = N + 2,
    Index = 1..I.

% Bias
neuron(Type, Layer, Index) :-
    Type = bias,
    num_hidden_layers(H),
    Layer = 1..H + 1,
    Index = 0.


%%% Excitation Functions / Forward Pass %%%

% Use random input values for testing
% neuron(input, 1, Index, Value) :-
%     neuron(input, 1, Index),
%     Value = @random_value(1, Index).  % Passing in args allows for unique values.
neuron(input, 1, 1, 12345).
neuron(input, 1, 2, 67890).

% Set bias neurons
% neuron(bias, Layer, 0, -1000000) :-  % 1e6 precision
neuron(bias, Layer, 0, -10000) :-  % 1e4 precision
    neuron(bias, Layer, 0).

% Excitation function
neuron(Type, Layer, Index, Value) :-
    neuron(Type, Layer, Index),
    Layer > 1,
    Index > 0,
    % Value = #sum { (Source_Value*Weight)/1000000 :  % 1e6 precision
    Value = #sum { (Source_Value*Weight)/10000 :  % 1e4 precision
            edge(Layer - 1, Source_Index, Layer, Index, Weight),
            neuron(_, Layer - 1, Source_Index, Source_Value) }.


%% Activation Functions


% #show neuron/3.
#show neuron/4.
% #show neuron/5.
#show edge/5.
% #show excitation/3.
% #show val/3.


#script (python)
import clingo
import random

def random_value(Layer, Index):
    # Returns a scaled integer value between 0 and 1 with 6 decimal places. (python stores 17ish though)
    val = random.uniform(0, 10)
    # return clingo.String(f"{val:.6f}")
    return clingo.Number(int(val * 1e6))
    # return clingo.Number(int(val * 1e4))
    # return clingo.String(str(val))

def random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index):
    # Generate a single random float as a scaled integer with 6 decimal places.
    val = random.uniform(-0.5, 0.5)
    return clingo.Number(int(val * 1e6))
    # return clingo.Number(int(val * 1e4))
    # return clingo.String(str(val))

def multiply(x, y):
    xfloat = float(x.string)
    yfloat = float(y.string)
    mult = xfloat * yfloat
    return clingo.String(str(mult))

#end.