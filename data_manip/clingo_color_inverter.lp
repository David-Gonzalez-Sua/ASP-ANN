%% Inverts the color of a single image in .lp format

%%% NOT NECESSARY?
%% 28 rows and 28 coloumns exist
%row(1..28).
%col(1..28).
%% 256 colors exist
%color(0..255).
%% 10 labels exist
%label(0..9).


%% Each inverted pixel has the same properties as a pixel, but with an inverted color
invPixel(Row, Col, NewColor, Label) :- pixel(Row, Col, Color, Label), NewColor = 255 - Color.


%% Each inverted pixel row and coloumn combination corresponds to a single pixel NOT NECESSARY??
%1{ invPixel(Row, Col, Color, Label) : color(Color), label(Label)}1 :- row(Row), col(Col).

#show invPixel/4.
