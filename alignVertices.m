function [transformedVertices, inCap] = alignVertices(mri_data, vertices)

% Correct vertices for "nodding".

% Returns the vertices (argument vertices) rotated in a way that the line
% between the lower end of accumbens and ceribellum is parallel with the axial
% plane.

% This simple version (compared to alignVerticesAdvanced.m) computes the
% correction angle, then performs the correction directly in the RAS system of
% vertices. The vertices coordinates are not based on anatomical reference 
% points, they are similar to the "scanner" system only with other signs, order
% and constant offset.

% Also returns a list of true/false values signifying whether each vertex is
% in the "cap" -- the region used for bone marrow intensity analysis.

% Test: See script testAlignVertices for an example of how to run it.

% The vol data in coordinates of the scanner -- contains the part of brain.
m2 = squeeze(mri_data.vol(:,120,:));

% Find upper part of cerebellum
[y1,x1] = find(m2 == 47);
p1 = find(y1 == min(y1));
x1 = x1(p1(1)); y1=y1(p1(1));

% Find upper part of accumbens
[y2,x2] = find(m2 == 58);
p2 = find(y2 == min(y2));
x2=x2(p2(1)); y2=y2(p2(1));

% Start and end of line connecting these reference points, in scanner system.
dy = y2 - y1;
dx = x2 - x1;

% Rotation about the left-right axis.

% TEST: make a larger angle
% Test disabled: dy += 30;

%Necessary code below, not part of "TEST"
xymag = sqrt(dx*dx+dy*dy);
sintheta = dy / xymag; % opposite side of rotation angle
costheta = dx / xymag; % adjacent side of rotation angle

% ALT code: rotate in the vertices' original RAS system. Much Simple. Wow.
rotation = [
    1 0 0
    0 costheta -sintheta
    0 sintheta costheta
  ];
transformedVertices = (rotation * vertices')';

% Determine whether in the cap.
capMidPoint = mri_data.vox2ras * [(y1 + y2) / 2; 120; (x1 + x2) / 2; 1];
capSup = capMidPoint(3);
inCap = transformedVertices(:, 3) > capSup;
