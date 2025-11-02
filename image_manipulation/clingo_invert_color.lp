%% Inverts the color of a single image in .lp format

%% Each inverted pixel has the same properties as a pixel, but with an inverted color
invPixel(Row, Col, NewColor, Label) :- pixel(Row, Col, Color, Label), NewColor = 255 - Color.

#show invPixel/4.
