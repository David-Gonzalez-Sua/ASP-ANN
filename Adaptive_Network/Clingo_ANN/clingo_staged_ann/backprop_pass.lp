% backprop_pass.lp
% This file defines the backpropagation pass logic for the ANN model.
% Usage:
% clingo --parallel-mode=8 --verbose=3 ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/working_memory.lp ./Adaptive_Network/Clingo_ANN/clingo_staged_ann/backprop_pass.lp -c layer=<val>
% 
%% Reference for network structure and parameters (can be removed later)
% input_size(784).
% hidden_depth(2).
% hidden_size(1, 128).
% hidden_size(2, 128).
% output_size(10).
% neuron(Type, Layer, Index).
% edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight).

