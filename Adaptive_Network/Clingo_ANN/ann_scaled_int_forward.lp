%% To visualize graph:
%% clingo .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_weights5000.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%%
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_784i_128h_2n_10o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_forward.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% 
%% TODO, notes, and ideas for this file:
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


%%% Network Parameters and Structure for reference %%%
% % input_size(784).
% % hidden_size(128).
% % num_hidden_layers(2).
% % output_size(10).
% % edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight).
% % neuron(Type, Layer, Index).


%%% ======== Forward Pass ======== %%%

%% Hardcoded neuron values for testing
% neuron(input, 1, 1, 12345).
% neuron(input, 1, 2, 67890).
% neuron(input, 1, 3, 13579).

%% Set bias neurons
% 1e4 precision
neuron(bias, Layer, 0, -10000) :- 
    neuron(bias, Layer, 0).

% 1e6 precision
% neuron(bias, Layer, 0, -1000000) :-  
    % neuron(bias, Layer, 0).


%%% Excitation Functions %%%
excitation(hidden, 2, Index, Value) :-
    neuron(hidden, 2, Index), Index > 0,
    % Value = #sum { (Source_Value/(10000/Weight)) :  % 1e4 precision
    Value = #sum { (Source_Value*Weight) :  % 1e4 precision (actual input nuerons in data havent been scaled yet)
            edge(1, Source_Index, 2, Index, Weight),
            neuron(_, 1, Source_Index, Source_Value) }.

excitation(hidden, Layer, Index, Value) :-
    neuron(hidden, Layer, Index),
    Layer > 2, Index > 0,
    Value = #sum { 
            (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
                edge(Layer - 1, Source_Index, Layer, Index, Weight),
                neuron(_, Layer - 1, Source_Index, Source_Value),
                Weight != 0 ;
            0, Source_Index :
                edge(Layer - 1, Source_Index, Layer, Index, Weight),
                neuron(_, Layer - 1, Source_Index, Source_Value),
                Weight = 0 }.

excitation(output, Layer, Index, Value) :-
    neuron(output, Layer, Index),
    num_hidden_layers(N), Layer = N + 2,
    Value = #sum { 
            (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
                edge(Layer - 1, Source_Index, Layer, Index, Weight),
                neuron(_, Layer - 1, Source_Index, Source_Value),
                Weight != 0 ;
            0, Source_Index :
                edge(Layer - 1, Source_Index, Layer, Index, Weight),
                neuron(_, Layer - 1, Source_Index, Source_Value),
                Weight = 0 }.

% Enforce 1 value per neuron
:- neuron(Type, Layer, Index, Value1), neuron(Type, Layer, Index, Value2), Value1 != Value2.

% Kept for future reference
% BUG: Excitation function is not summing correctly for layes past 2. It is taking only a single neuron as the full sum.
%      When values (and weights) are the same throughout a given layer, it breaks the combinations and causes the sum to only take a single neuron!
%      FIX: Add the source index as a condition to the sum to break the combinations and allow for the full sum to be calculated.


%%% Activation Functions %%%

% ReLU activation function
neuron(Type, Layer, Index, Value) :-
    excitation(Type, Layer, Index, Value),
    num_hidden_layers(N), Layer < N + 2,
    Layer > 1, Index > 0, Value > 0.

neuron(Type, Layer, Index, 0) :-
    excitation(Type, Layer, Index, Value),
    num_hidden_layers(N), Layer < N + 2,
    Layer > 1, Index > 0, Value <= 0.

% Pushes the excitation value through to the output layer without modification for performance purposes
neuron(output, Layer, Index, Value) :-
    excitation(output, Layer, Index, Value).

% Show new excitation atom for output nodes
excitation(output, Layer, Index, Value, 1) :-
    excitation(output, Layer, Index, Value).

% ISSUE: When the activation function is applied to the output layer in any form in this same program, the runtime explodes.
%        This is likely related to circular reasoning between the excitation and activation functions for the output layer, which causes the search space to explode.
%        FIX: Move the activation function for the output layer to a separate program that depends on the forward pass program. (to the backpropogating step, perhaps?)


%%% Activate only loaded input neurons for testing
neuron(input, 1, Index, Value, 1) :-
    neuron(input, 1, Index, Value),
    Index <= I,
    input_size(I).
neuron(Type, Layer, Index, Value, 1) :-
    neuron(Type, Layer, Index, Value),
    Type != input.

% Output network information.
#show neuron/5.
#show edge/5.
#show excitation/5.
#show input_size/1.
#show hidden_size/1.
#show num_hidden_layers/1.
#show output_size/1.