% forward_pass.lp
% This file defines the forward pass logic for the ANN model.
% Usage:
% clingo
%
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/forward_pass.lp -c layer=<val>
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/dummy_data.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/forward_pass.lp -c layer=<val>
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
neuron(bias, layer, 0, -10000) :-
    neuron(bias, layer, 0).

% Excitation functions from source layer to target layer
% excitation(Target_Layer, Target_Index, Excitation) :-
%     neuron(_, Target_Layer, Target_Index), Target_Index > 0,
%     Excitation = #sum { 
%         (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
%             edge(layer, Source_Index, Target_Layer, Target_Index, Weight),
%             neuron(_, layer, Source_Index, Source_Value),
%             Weight != 0 ;
%         0, Source_Index :  % Checking for division by zero
%             edge(layer, Source_Index, Target_Layer, Target_Index, Weight),
%             neuron(_, layer, Source_Index, Source_Value),
%             Weight == 0 }.
excitation(Target_Layer, Target_Index, Excitation) :-
    neuron(_, Target_Layer, Target_Index), 
    Target_Layer = layer + 1, Target_Index > 0,
    Excitation = #sum { ((Source_Value*Weight)/10000), Source_Index :  % 1e4 precision
            edge(layer, Source_Index, Target_Layer, Target_Index, Weight),
            neuron(_, layer, Source_Index, Source_Value) }.
#show excitation/3.

% Activation functions for target layer (ReLU)


% Outputs
#show neuron/3.
#show edge/5.
#show input_size/1.
#show hidden_depth/1.
#show hidden_size/2.
#show output_size/1.