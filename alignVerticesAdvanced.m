function [transformedVertices, inCap] = alignVertices(mri_data, vertices)

% Correct vertices for "nodding".

% This advanced code transforms everything to the scanner system, where we have
% the reference points for the head orientation (from mri_data.vol). Then
% performs the rotation in scanner system, and transforms back.

% **** This doesn't work ****

% Returns the vertices (argument vertices) transformed in such a way
% that the lower edge of the "swimming cap" is rotated parallel to the third 
% scanner axis, approximately the posterior-anterior axis.

% Also returns a list of true/false values signifying whether each vertex is
% above the cap.

% Test: See script testAlignVertices for an example of how to run it.

% The vol data in coordinates of the scanner -- contains the part of brain.
m2 = squeeze(mri_data.vol(:,120,:));

% Convert input vertices to scanner system, same as m2. A fourth coordinate,
% always value 1, is added for technical reasons.
scannerVertices = inv(mri_data.vox2ras)* [vertices ones(size(vertices, 1), 1)]';

% Approximate directions, they are not exactly the same as the RAS coords
% used in vertices.
% First dimension fixed = top down view = fixed height (Superior/Inferior)
% Second dimension fixed = side view = fixed left/right slice
% Third dimension fixed = view from back / front = fixed posterior/anterior

% Find upper part of cerebellum
[y1,x1] = find(m2 == 47);
p1 = find(y1 == min(y1));
x1 = x1(p1(1)); y1=y1(p1(1));

% Find upper part of accumbens
[y2,x2] = find(m2 == 58);
p2 = find(y2 == min(y2));
x2=x2(p2(1)); y2=y2(p2(1));

% Start and end of line connecting these reference points, in scanner system.
startpt = [y1; 120; x1; 1];
endpt = [y2; 120; x2; 1];

% We need to shift all data so that the origin is at the midpoint of the line
% segment described above. Then we can use a simple rotation around the second
% axis.

mid = (startpt + endpt) / 2;

shiftedVertices = scannerVertices - mid;

% Rotation about the left-right axis.

% Difference of the endpoint from the start point represents a vector between
% these two points.
vector = endpt - startpt;
% TEST: make a larger angle
vector = vector + [-30; 0; 0; 0]

xymag = sqrt(vector(1:3)'*vector(1:3));
sintheta = vector(1) / xymag; % opposite side of rotation angle
costheta = vector(3) / xymag; % adjacent side of rotation angle

% Rotation matrix in scanner system. Rotate around the Left-Right axis.
rotation = [
    costheta 0 -sintheta 0
    0 1 0 0
    sintheta 0 costheta 0
    0 0 0 1 
  ];
scannerRotatedVertices = rotation * shiftedVertices;
inCap = scannerRotatedVertices(1,:) > 0;

% Shift back, the midpoint location is arbitrary, we restore original positions.
scannerTransformedVertices = scannerRotatedVertices + mid;
  
% Convert back to coordinate system of vertices
transformedVertices4 = (mri_data.vox2ras * scannerTransformedVertices);
transformedVertices = transformedVertices4'(:, 1:3);

