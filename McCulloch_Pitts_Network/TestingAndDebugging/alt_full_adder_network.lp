%% Full binary adder implementation using a McCulloch-Pitts network


%%% FULL ADDER NETWORK CONNECTIONS %%%

% %% Graph Edges
% % Layer 1 -> 2
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = a,
%     neuron(Target_ID, Index, _), Target_ID = xor1.
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = a,
%     neuron(Target_ID, Index, _), Target_ID = and1.

% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = b,
%     neuron(Target_ID, Index, _), Target_ID = xor1.
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = b,
%     neuron(Target_ID, Index, _), Target_ID = and1.

% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = carry,
%     neuron(Target_ID, Index, _), Target_ID = xor2.
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = carry,
%     neuron(Target_ID, Index, _), Target_ID = and2.

% % Layer 2 -> 3
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = xor1,
%     neuron(Target_ID, Index, _), Target_ID = xor2.
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = xor1,
%     neuron(Target_ID, Index, _), Target_ID = and2.

% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = and1,
%     neuron(Target_ID, Index, _), Target_ID = or1.

% % Layer 3 -> 4, 5
% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = xor2,
%     neuron(Target_ID, Index, _), Target_ID = sum_out.

% edge(Source_ID, Target_ID, Index, Val) :- 
%     neuron(Source_ID, Index, Val), Source_ID = and2,
%     neuron(Target_ID, Index, _), Target_ID = or1.

% % Layer 4 -> 5
% edge(Source_ID, Target_ID, Index_Target, Val) :- 
%     neuron(Source_ID, Index_Source, Val), Source_ID = or1,
%     neuron(Target_ID, Index_Target, _), Target_ID = carry, 
%     Index_Target = Index_Source + 1.