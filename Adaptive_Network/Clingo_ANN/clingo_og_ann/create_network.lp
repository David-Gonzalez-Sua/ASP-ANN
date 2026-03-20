%% Creates a network structure based on specified parameters.
%% clingo .\Adaptive_Network\Clingo_ANN\create_network.lp | python .\Adaptive_Network\Clingo_ANN\save_network.py -s True -p 4 -f 'randomized'
%% -s = Scaled Integers bool, -p = Precision for scaled integers (4 or 6), -f = Unique identifier for output file name (default 'randomized')
%%
%% clingo .\Adaptive_Network\Clingo_ANN\create_network.lp -c i=<val> h=<val> n=<val> o=<val> | python .\Adaptive_Network\Clingo_ANN\save_network.py -s True -p 4 -f 'randomized'
%% -s = Scaled Integers bool, -p = Precision for scaled integers (4 or 6), -f = Unique identifier for output file name (default 'randomized')
%% i = input size, h = hidden layer size, n = number of hidden layers, o = output size

%%% Network Parameters %%%
#const i = 784.  % Input size
#const h = 128.  % Hidden layer size
#const n = 2.    % Number of hidden layers
#const o = 10.   % Output size
#const w = 1.    % Randomized weight boolean (1 for True, 0 for False. False will set all weights to 0.5)

input_size(i).
hidden_size(h).
num_hidden_layers(n).
output_size(o).

% input_size(784).
% hidden_size(128).
% num_hidden_layers(2).
% output_size(10).

% input_size(3).
% hidden_size(5).
% num_hidden_layers(2).
% output_size(2).

% input_size(2).
% hidden_size(3).
% num_hidden_layers(2).
% output_size(1).


%%% Network Structure %%%
edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight) :-
    neuron(_, Source_Layer, Source_Index),
    neuron(_, Target_Layer, Target_Index),
    Target_Layer = Source_Layer + 1,
    Target_Index > 0,
    Weight = @random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index).  % Passing in args allows for unique values.
    % Weight = 5000.  % 0.5 * 1e4
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


%%% Show network structure and parameters %%%
#show neuron/3.
#show edge/5.
#show input_size/1.
#show hidden_size/1.
#show num_hidden_layers/1.
#show output_size/1.


%%% Python script for generating random weights as scaled integers %%%
#script (python)
import clingo
import random
import math


def random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index):
    # Generate a single random float as a scaled integer with 6 decimal places.
    val = random.uniform(-0.5, 0.5)
    # return clingo.Number(int(val * 1e6))
    return clingo.Number(int(val * 1e4))
    # return clingo.String(str(val))

#end.