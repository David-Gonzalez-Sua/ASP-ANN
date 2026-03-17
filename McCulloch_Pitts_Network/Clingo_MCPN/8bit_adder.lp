%% Use: clingo '.\McCulloch-Pitts_Network\Clingo_MCPN\8bit_adder.lp' '.\McCulloch-Pitts_Network\Clingo_MCPN\full_adder_network.lp' '.\McCulloch-Pitts_Network\Clingo_MCPN\logical_neuron.lp' '.\McCulloch-Pitts_Network\Clingo_MCPN\decimal_binary_converter.lp'
%% Pipe into this script to visualize graph: | python '.\McCulloch-Pitts_Network\Clingo_MCPN\graph_visualizer.py' | dot -T pdf -o '.\McCulloch-Pitts_Network\Clingo_MCPN\network_visualizer.pdf'


%%% SHOW SUM IN A READABLE FORMAT %%%

%% Show answer in binary
sum_bit(Index, Val) :- neuron_output(output, Index, Val).

binary_sum(B7, B6, B5, B4, B3, B2, B1, B0) :- 
    sum_bit(7, B7), sum_bit(6, B6),
    sum_bit(5, B5), sum_bit(4, B4),
    sum_bit(3, B3), sum_bit(2, B2),
    sum_bit(1, B1), sum_bit(0, B0).

% #show sum_bit/2.
#show binary_sum/8.
#show binary_a/8.
#show binary_b/8.

%% Show edges to create graph visualization
#show edge/4.