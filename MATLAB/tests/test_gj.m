%% UNIT TEST FOR GABOR JET

disp('TESTING FOR GABOR JET'); 

load('128X.mat');

J = reshape(X(2,:), [128 128])';
[wholeGridMag, wholeGridPhase, wholeGridPos] = GWTWgrid_Simple(J,0,0, 2*pi, 2, 8); 

disp('TESTING PASSED'); 