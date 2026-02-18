%% To visualize graph:
%% clingo .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%% clingo .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_3i_5h_2n_2o_weights5000.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
%%
%% clingo .\MNIST_Dataset\Clingo_Facts\train_data\train_image_0.lp .\Adaptive_Network\Clingo_ANN\models\ann_scaled_int_784i_128h_2n_10o_randomized.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'
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


% %%% Network Parameters %%%
% % # Set network parameters
% % input_size(784).
% % hidden_size(128).
% % num_hidden_layers(2).
% % output_size(10).

% input_size(3).
% hidden_size(5).
% num_hidden_layers(2).
% output_size(2).

% % input_size(2).
% % hidden_size(3).
% % num_hidden_layers(2).
% % output_size(1).


% %%% Network Structure %%%
% edge(Source_Layer, Source_Index, Target_Layer, Target_Index, Weight) :-
%     neuron(_, Source_Layer, Source_Index),
%     neuron(_, Target_Layer, Target_Index),
%     Target_Layer = Source_Layer + 1,
%     Target_Index > 0,
%     % Weight = @random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index).  % Passing in args allows for unique values.
%     Weight = 5000.  % 0.5 * 1e4
%     % Weight = 500000.  % 0.5 * 1e6


% %%% Neuron Definitions %%%

% % Input
% neuron(Type, Layer, Index) :- 
%     Type = input, 
%     input_size(I), 
%     Layer = 1, 
%     Index = 1..I.

% % Hidden
% neuron(Type, Layer, Index) :- 
%     Type = hidden, 
%     hidden_size(I), 
%     num_hidden_layers(H),  
%     Layer = 2..H + 1, 
%     Index = 1..I.

% % Output
% neuron(Type, Layer, Index) :- 
%     Type = output, 
%     output_size(I), 
%     num_hidden_layers(N),
%     Layer = N + 2,
%     Index = 1..I.

% % Bias
% neuron(Type, Layer, Index) :-
%     Type = bias,
%     num_hidden_layers(H),
%     Layer = 1..H + 1,
%     Index = 0.


%%% Excitation Functions / Forward Pass %%%

% Use random input values for testing
% neuron(input, 1, Index, Value) :-
%     neuron(input, 1, Index),
%     Value = @random_value(1, Index).  % Passing in args allows for unique values.
neuron(input, 1, 1, 12345).
neuron(input, 1, 2, 67890).
neuron(input, 1, 3, 13579).

% Set bias neurons
% neuron(bias, Layer, 0, -1000000) :-  % 1e6 precision
neuron(bias, Layer, 0, -10000) :-  % 1e4 precision
    neuron(bias, Layer, 0).

% Excitation function
% excitation(Type, Layer, Index, Value) :-
%     neuron(Type, Layer, Index),
%     Layer > 1,
%     Index > 0,
%     % Value = #sum { (Source_Value*Weight)/1000000 :  % 1e6 precision
%     % Value = #sum { (Source_Value*Weight)/10000 :  % 1e4 precision
%     %         edge(Layer - 1, Source_Index, Layer, Index, Weight),
%     %         neuron(_, Layer - 1, Source_Index, Source_Value) }.
%     Value = #sum { (Source_Value/(10000/Weight)) :  % 1e4 precision
%             edge(Layer - 1, Source_Index, Layer, Index, Weight),
%             neuron(_, Layer - 1, Source_Index, Source_Value) }.

excitation(Type, Layer, Index, Value) :-
    neuron(Type, Layer, Index),
    Layer = 2, Index > 0,
    Value = #sum { (Source_Value/(10000/Weight)) :  % 1e4 precision
    % Value = #sum { (Source_Value*Weight) :  % 1e4 precision (input nuerons havent been scaled yet)
            edge(Layer - 1, Source_Index, Layer, Index, Weight),
            neuron(_, Layer - 1, Source_Index, Source_Value) }.

excitation(Type, Layer, Index, Value) :-
    neuron(Type, Layer, Index),
    Layer > 2, Index > 0,
    Value = #sum { (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
            edge(Layer - 1, Source_Index, Layer, Index, Weight),
            neuron(_, Layer - 1, Source_Index, Source_Value) }.

% excitation(Type, Layer, Index, Value) :-
%     neuron(Type, Layer, Index),
%     Layer > 2, Index > 0,
%     Value = #sum { (Source_Value/(10000/Weight)) :  % 1e4 precision
%             edge(Layer - 1, Source_Index, Layer, Index, Weight),
%             neuron(_, Layer - 1, Source_Index, Source_Value) }.

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

% Output layer uses excitation value for testing
neuron(output, Layer, Index, Value) :-
    excitation(output, Layer, Index, Value).

% Softmax activation function
% neuron(output, Layer, Index, Value) :-
%     excitation(output, Layer, Index, ValueOriginal),
%     num_hidden_layers(N), output_size(I), 
%     Layer = N + 2, Index = 1..I, 
%     SumExp = #sum { @exp(V) : excitation(output, Layer, Index2, V), Index2 = 1..I },
%     Value = @exp_div(ValueOriginal, SumExp).

% Normalized Sum activation function
% neuron(output, Layer, Index, Value) :-
%     excitation(output, Layer, Index, Exc),
%     num_hidden_layers(N), output_size(I), 
%     Layer = N + 2, Index = 1..I,
%     Value = #sum { Val : excitation(output, Layer, Index2, Val) }.
    % Value = Value / I.
    % Value = 10000 * ValueOg / Sum.

% excitation(Type, Layer, Index, Value) :-
%     neuron(Type, Layer, Index),
%     Layer > 2, Index > 0,
%     Value = #sum { (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
%             edge(Layer - 1, Source_Index, Layer, Index, Weight),
%             neuron(_, Layer - 1, Source_Index, Source_Value) }.

% output_sum(Sum) :- 
%     num_hidden_layers(N), output_size(I),
%     Layer = N + 2, 
%     Sum = #sum { V, Index : excitation(output, Layer, Index, V), Index = 1..I }.
    % Layer = N + 2, Index = 1..I, 
    % Sum = #sum { V : excitation(output, _, Index, V) }.
    % Sum = #sum { V : excitation(output, Layer, Index, V) }.
    % Sum = 10101010.

% probability(Layer, Index, Prob) :-
%     excitation(output, Layer, Index, Value),
%     output_sum(Layer, SumValue).

% neuron(output, Layer, Index, Prob) :-
%     excitation(output, Layer, Index, Value),
%     output_sum(Layer, Sum),
%     % S = SumValue / 1000, S != 0,  %% Rescale sum for precision
%     % Prob = (Value / S) * 10. 
%     Prob = Sum.
%     % Prob = ((Value / (SumValue / 1000)) * 10).

% excitation(Type, Layer, Index, Value) :-
%     neuron(Type, Layer, Index),
%     Layer > 2, Index > 0,
%     Value = #sum { (Source_Value/(10000/Weight)), Source_Index :  % 1e4 precision
%             edge(Layer - 1, Source_Index, Layer, Index, Weight),
%             neuron(_, Layer - 1, Source_Index, Source_Value) }.


%%% Hacked together way to activate output neurons %%%
% sum_output(Sum) :- neuron(output, Layer, Index, Value), Sum = #sum { Value : neuron(output, Layer, Index, Value) }.

% sum_output(Sum) :-
%     excitation(output, Layer, 1, Out1),
%     excitation(output, Layer, 2, Out2),
%     excitation(output, Layer, 3, Out3),
%     excitation(output, Layer, 4, Out4),
%     excitation(output, Layer, 5, Out5),
%     excitation(output, Layer, 6, Out6),
%     excitation(output, Layer, 7, Out7),
%     excitation(output, Layer, 8, Out8),
%     excitation(output, Layer, 9, Out9),
%     excitation(output, Layer, 10, Out10),
%     Sum = Out1 + Out2 + Out3 + Out4 + Out5 + Out6 + Out7 + Out8 + Out9 + Out10.

% sum_output(Sum) :-
%     excitation(output, Layer, 1, Out1),
%     excitation(output, Layer, 2, Out2),
%     Sum = Out1 + Out2.
% % #show sum_output/1.
% neuron(output, Layer, Index, Value) :-
%     excitation(output, Layer, Index, Exc), 
%     sum_output(Sum),
%     Value = ((Exc / (Sum / 1000)) * 10).
    % Value = 1.

% neuron(output, Layer, Index, Value) :-
%     excitation(output, Layer, 1, Out1),
%     excitation(output, Layer, 2, Out2),
%     Value = @p_dist(Index, Out1, Out2),
%     Index = 1..2.

% Activate only loaded input neurons for testing
neuron(input, 1, Index, Value, 1) :-
    neuron(input, 1, Index, Value),
    Index <= I,
    input_size(I).
neuron(Type, Layer, Index, Value, 1) :-
    neuron(Type, Layer, Index, Value),
    Type != input.
#show neuron/5.

#show edge/5.
% #show excitation/4.
% #show neuron/3.
% #show neuron/4.
% #show neuron/5.
% #show val/3.


#script (python)
import clingo
import random
import math

def random_value(Layer, Index):
    # Returns a scaled integer value between 0 and 1 with 6 decimal places. (python stores 17ish though)
    val = random.uniform(0, 10)
    # return clingo.String(f"{val:.6f}")
    return clingo.Number(int(val * 1e6))
    # return clingo.Number(int(val * 1e4))
    # return clingo.String(str(val))

def random_weight(Source_Layer, Source_Index, Target_Layer, Target_Index):
    # Generate a single random float as a scaled integer with 6 decimal places.
    # val = random.uniform(-0.5, 0.5)
    val = random.uniform(0, 1)
    # return clingo.Number(int(val * 1e6))
    return clingo.Number(int(val * 1e4))
    # return clingo.String(str(val))

def multiply(x, y):
    xfloat = float(x.string)
    yfloat = float(y.string)
    mult = xfloat * yfloat
    return clingo.String(str(mult))

def exp(x):
    xfloat = float(x.number)/1e4  # Rescale back to original float value
    exp_val = math.exp(xfloat) * 1e4  # Scale back up to an integer representation
    return clingo.Number(int(exp_val))

def exp_div(x, sum_exp):
    try:
        xfloat = float(x.number)/1e4  # Rescale back to original float value
        sum_exp_float = float(sum_exp.number)/1e4  # Rescale back to original float value
        exp_div_val = (math.exp(xfloat) / sum_exp_float) * 1e4  # Scale back up to an integer representation
        return clingo.Number(int(exp_div_val))
    except:
        return clingo.Number(0)

# def softmax(values):
#     # Convert the input values from strings to floats
#     float_values = [float(v.string) for v in values]
#   
#     # Compute the softmax values
#     max_val = max(float_values)  # For numerical stability
#     exp_values = [math.exp(v - max_val) for v in float_values]
#     sum_exp = sum(exp_values)
#     softmax_values = [ev / sum_exp for ev in exp_values]
#   
#     # Convert the softmax values back to strings and return as clingo.String objects
#     return [clingo.String(f"{sv:.6f}") for sv in softmax_values]

# def softmax(z):
#     # Takes in a vector, returns a vector
#     m = max(z)
#     exps = [math.exp(zi - m) for zi in z]
#     s = sum(exps)
#     y = [yi / s for yi in exps]
#     return y

def p_dist(index, out1, out2):
    out1_float = float(out1.number)/1e4
    out2_float = float(out2.number)/1e4
    total = out1_float + out2_float
    if total == 0:
        return clingo.Number(0)
    if index == 1:
        prob = (out1_float / total) * 1e4
        return clingo.Number(int(prob))
    else:
        prob = (out2_float / total) * 1e4
        return clingo.Number(int(prob))

#end.