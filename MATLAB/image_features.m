function features = image_features(filepath)

I = imread(char(filepath)); 
J = imresize(I, [256 256]);
[JetsMagnitude, JetsPhase, GridPosition] = GWTWgrid_Simple(J,0,0); 
% we can ignore grid pos because they are the same for every image 
features = [JetsMagnitude(:); JetsPhase(:)];
%% complex = 0 simple = 0 for 2nd param
%% grid size 0 => 10*10 ugh i'll have to code it myself
end