%% UNIT TEST FOR GABOR JET

sprintf('TESTING FOR GABOR JET'); 

load('X.mat');

J = reshape(X(2,:), [48 48])';
[wholeGridMag, wholeGridPhase, wholeGridPos] = GWTWgrid_Simple(J,0,0, 2*pi, 2, 8); 

sprintf('TESTING PASSED') 