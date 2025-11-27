%% Converts decimal numbers to binary and vice versa
%% clingo decimal_binary_converter.lp -c n=<num> -c b=<bits>

decimal(7, n).
bits(b).

%decimal(Index, Num).
%bit(Index, Bit).

index(0..B) :- bits(B).

%% Decimal to binary conversion
decimal(Index, Num) :- decimal(IndexLast, NumLast), index(Index), Index = IndexLast + 1, Index < B, bits(B), Num = NumLast - 2**IndexLast, NumLast / 2**Index >= 1.
decimal(Index, NumLast) :- decimal(IndexLast, NumLast), index(Index), Index = IndexLast + 1, Index < B, bits(B), Num = NumLast, NumLast / 2**Index < 1.

bit(Index, 1) :- decimal(Index, Num), Num / 2**Index >= 1.
bit(Index, 0) :- decimal(Index, Num), Num / 2**Index < 1.

%% Binary to decimal conversion
%decimal(Num) :- Num = #sum{B*2**I : bit(I,B)}.

%#show decimal/1.
#show bit/2.

