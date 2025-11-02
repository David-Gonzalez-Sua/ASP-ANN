%% Flips a single image over the vertical axis in .lp format

%% Each flipped pixel has the same properties as a pixel, but 
flippedPixel(Row, NewCol, Color, Label) :- pixel(Row, Col, Color, Label), NewCol = 28 - Col.

#show flippedPixel/4.