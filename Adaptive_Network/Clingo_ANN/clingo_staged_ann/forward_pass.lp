% forward_pass.lp
% This file defines the forward pass logic for the ANN model.
% Usage:
% clingo
%
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/forward_pass.lp -c layer=<val>
%
%% Reference for network structure and parameters (can be removed later)
% input_size(784).
% hidden_depth(2).
% hidden_size(1, 128).
% hidden_size(2, 128).
% output_size(10).
% neuron(Type, Layer, Index).
% edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight).


% Current Source Layer
#const layer = 0.

% Set bias neurons for current layer
% 1e4 precision
neuron(bias, Layer, 0, -10000) :-
    neuron(bias, Layer, 0).

% Excitation functions from source layer to target layer


% Activation functions for target layer (ReLU)


% Outputs
#show neuron/3.
#show edge/5.
#show input_size/1.
#show hidden_depth/1.
#show hidden_size/2.
#show output_size/1.