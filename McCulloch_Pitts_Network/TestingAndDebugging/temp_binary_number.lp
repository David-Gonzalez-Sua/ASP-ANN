%% McCulloch-Pitts Network representation of binary numbers


%% Holds binary number representations
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

% Expected result: Binary 40
% binary_e(0, 0, 1, 0, 1, 0, 0, 0).
% bit(e, 0, 0).
% bit(e, 1, 0).
% bit(e, 2, 0).
% bit(e, 3, 1).
% bit(e, 4, 0).
% bit(e, 5, 1).
% bit(e, 6, 0).
% bit(e, 7, 0).