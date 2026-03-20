%% Use: clingo .\Adaptive_Network\Clingo_ANN\model_snapshots\ann_scaled_int_3i_5h_2n_2o_snapshot.lp .\Adaptive_Network\Clingo_ANN\ann_scaled_int_backprop.lp | python .\Adaptive_Network\Clingo_ANN\graph_visualizer.py | dot -T pdf -o '.\Adaptive_Network\Clingo_ANN\graphs\network_visualizer.pdf'


% Find the prob dist of output layer
% neuron(output, Layer, Index, Value) :-
%     excitation(output, Layer, Index, Exc),
%     excitation(output, Layer, 1, Exc1),
%     excitation(output, Layer, 2, Exc2),
%     num_hidden_layers(H), Layer = H + 2,
%     output_size(I), Index = 1..I,
%     Value = 10000 * Exc / (Exc1 + Exc2).

% Find the softmax value of each output neuron
neuron(output, Layer, Index, Value, 1) :- 
    num_hidden_layers(H), Layer = H + 2,
    output_size(I), Index = 1..I, I = 2,  % Only for 2 output neurons
    excitation(output, Layer, Index, Exc),
    excitation(output, Layer, 1, Exc1),
    excitation(output, Layer, 2, Exc2),
    Value = @softmax_scaled(Exc, Exc1, Exc2).

neuron(output, Layer, Index, Value, 1) :- 
    num_hidden_layers(H), Layer = H + 2,
    output_size(I), Index = 1..I, I = 10,  % Only for 10 output neurons
    excitation(output, Layer, Index, Exc),
    excitation(output, Layer, 1, Exc1),
    excitation(output, Layer, 2, Exc2),
    excitation(output, Layer, 3, Exc3),
    excitation(output, Layer, 4, Exc4),
    excitation(output, Layer, 5, Exc5),
    excitation(output, Layer, 6, Exc6),
    excitation(output, Layer, 7, Exc7),
    excitation(output, Layer, 8, Exc8),
    excitation(output, Layer, 9, Exc9),
    excitation(output, Layer, 10, Exc10),
    Value = @softmax_scaled(Exc, Exc1, Exc2, Exc3, Exc4, Exc5, Exc6, Exc7, Exc8, Exc9, Exc10).

% Overrides neuron values for output layer with softmax values.
neuron(Type, Layer, Index, Value, 1) :- neuron(Type, Layer, Index, Value), Type != output.

% Output network information.
#show neuron/5.
#show edge/5.
#show input_size/1.
#show hidden_size/1.
#show num_hidden_layers/1.
#show output_size/1.


#script (python)
import clingo
import math

def softmax_scaled(val, *values):
    # Convert scaled integers to floats, compute softmax values, and return as scaled integers.
    float_values = [(float(v.number)/1e4) for v in values]
    max_val = max(float_values)  # For numerical stability
    exp_values = [math.exp(v - max_val) for v in float_values]
    sum_exp = sum(exp_values)
    val_exp = math.exp((float(val.number)/1e4) - max_val)
    softmax = val_exp / sum_exp if sum_exp > 0 else 0.0
    return clingo.Number(int(softmax*1e4))

#end.