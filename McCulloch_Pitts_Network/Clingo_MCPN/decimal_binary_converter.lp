%% Temp numbers
% Binary 5
binary_a(0, 0, 0, 0, 0, 1, 0, 1).
bit(a, 0, 1).
bit(a, 1, 0).
bit(a, 2, 1).
bit(a, 3, 0).
bit(a, 4, 0).
bit(a, 5, 0).
bit(a, 6, 0).
bit(a, 7, 0).

% Binary 35
binary_b(0, 0, 1, 0, 0, 0, 1, 1).
bit(b, 0, 1).
bit(b, 1, 1).
bit(b, 2, 0).
bit(b, 3, 0).
bit(b, 4, 0).
bit(b, 5, 1).
bit(b, 6, 0).
bit(b, 7, 0).

% % Expected result: Binary 40
% binary_e(0, 0, 1, 0, 1, 0, 0, 0).
% bit(e, 0, 0).
% bit(e, 1, 0).
% bit(e, 2, 0).
% bit(e, 3, 1).
% bit(e, 4, 0).
% bit(e, 5, 1).
% bit(e, 6, 0).
% bit(e, 7, 0).


%% use: clingo decimal_binary_converter.lp -c n=<num> -c s=<bits> -c l=<label>
%% use: clingo decimal_binary_converter.lp -c input_a=<num> -c input_b=<num> -c bits=<bits> CHANGE LOGIC TO THIS
% note: s = size in bits. 'b' is avoided so that it can be used as an input label


num(n).
bits(s).
label(l).
bit_index(0..s). % Too many indexes?

num(N, Index) :- num(N), Index = 0.
num(N, Index) :- bit_index(Index), num(N_Last, Index - 1), N = N_Last - (2**Index), N >= 0.
num(N_last, Index) :- bit_index(Index), num(N_Last, Index - 1), N = N_Last - (2**Index), N < 0.

{ num(N, Index) : num(N) } 1 :- bit_index(Index).

bit_gen(Label, Index, Val, Num) :- label(Label), bit_index(Index), num(Num), Val = 

