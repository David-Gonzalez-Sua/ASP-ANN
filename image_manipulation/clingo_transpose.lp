%% Transposes a single image in .lp format

%% Each transposed pixel has the same properties as a pixel, but with its row and col swapped
transposedPixel(NewRow, NewCol, Color, Label) :- pixel(Row, Col, Color, Label), NewRow = Col, NewCol = Row.

#show transposedPixel/4.