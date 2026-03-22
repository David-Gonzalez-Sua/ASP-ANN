% forward_pass.lp
% This file defines the forward pass logic for the ANN model.
% Usage:
% clingo
%
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/forward_pass.lp -c layer=<val>
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/dummy_data.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/forward_pass.lp -c layer=<val>
%
% cp models/ann_3in_5_5hidden_2out_fixed-weights-test.lp working_memory.lp
% clingo working_memory.lp dummy_data.lp forward_pass.lp -c layer=0 | python3 save_network.py --save_values --scaled_integers --precision 2 > temp.lp
% clingo working_memory.lp dummy_data.lp forward_pass.lp -c layer=1 | python3 save_network.py --save_values --scaled_integers --precision 2 > temp.lp
% clingo working_memory.lp dummy_data.lp forward_pass.lp -c layer=2 | python3 save_network.py --save_values --scaled_integers --precision 2 > temp.lp
% mv temp.lp working_memory.lp
%
% TODO: Add normalization to the activation functions to prevent overflow issues (batch normalization or layer normalization probably)
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
%1e2 precision
neuron(bias, 0, 0, -1) :- neuron(bias, 0, 0).
neuron(bias, layer, 0, -100) :- neuron(bias, layer, 0), layer > 0.
% 1e4 precision
% neuron(bias, 0, 0, -1) :- neuron(bias, 0, 0).
% neuron(bias, layer, 0, -10000) :- neuron(bias, layer, 0).

% Excitation function from source layer to target layer
% input to hidden layer (need to scale input values)
excitation(Target_Layer, Target_Index, Excitation) :-
    neuron(_, Target_Layer, Target_Index), layer == 0,
    Target_Layer = layer + 1, Target_Index > 0,
    Excitation = #sum { (Source_Value*Weight), Source_Index :  % 1e2 precision
    % Excitation = #sum { (Source_Value*Weight, Source_Index :  % 1e4 precision
            edge(layer, Source_Index, Target_Layer, Target_Index, Weight),
            neuron(_, layer, Source_Index, Source_Value) }.
% hidden to hidden or hidden to output layer
excitation(Target_Layer, Target_Index, Excitation) :-
    neuron(_, Target_Layer, Target_Index), layer > 0,
    Target_Layer = layer + 1, Target_Index > 0,
    Excitation = #sum { ((Source_Value*Weight)/100), Source_Index :  % 1e2 precision
    % Excitation = #sum { ((Source_Value*Weight)/10000), Source_Index :  % 1e4 precision
            edge(layer, Source_Index, Target_Layer, Target_Index, Weight),
            neuron(_, layer, Source_Index, Source_Value) }.
#show excitation/3.

% Activation functions for target layer
% ReLU
neuron(Type, Target_Layer, Target_Index, Value) :-
    neuron(Type, Target_Layer, Target_Index),
    excitation(Target_Layer, Target_Index, Value),
    hidden_depth(H), Target_Layer = layer + 1,
    Target_Layer < H + 1, Target_Index > 0, Value > 0.

neuron(Type, Target_Layer, Target_Index, 0) :-
    neuron(Type, Target_Layer, Target_Index),
    excitation(Target_Layer, Target_Index, Value),
    hidden_depth(H), Target_Layer = layer + 1,
    Target_Layer < H + 1, Target_Index > 0, Value <= 0.

% Probability distribution activation for output layer
% Standard normalization
out_sum(Sum) :-
    hidden_depth(H), layer == H, output_size(O),
    Sum = #sum { Exc, Index : excitation(layer + 1, Index, Exc), Index = 1..O }.
#show out_sum/1.

neuron(Type, Target_Layer, Target_Index, Value) :-
    neuron(Type, Target_Layer, Target_Index),
    excitation(Target_Layer, Target_Index, Exc),
    hidden_depth(H), Target_Layer = layer + 1,
    layer == H, out_sum(Sum),
    Value = ((Exc + 1) * 100) / (Sum + 1).  % 1e2 precision
    % Value = ((Exc + 1) * 10000) / (Sum + 1).  % 1e4 precision
#show neuron/4.

% Outputs
% #show neuron/3.
% #show edge/5.
% #show input_size/1.
% #show hidden_depth/1.
% #show hidden_size/2.
% #show output_size/1.