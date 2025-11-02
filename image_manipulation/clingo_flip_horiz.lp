%% Flips a single image over the horizontal axis in .lp format

%% Each flipped pixel has the same properties as a pixel, but 
flippedPixel(NewRow, Col, Color, Label) :- pixel(Row, Col, Color, Label), NewRow = 28 - Row.

#show flippedPixel/4.