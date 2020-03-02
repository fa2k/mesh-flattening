% Test align vertices function

addpath matlab
mri_data = MRIread('extracted/aseg.nii');
[vertices,faces]=read_surf('FS_0025447_session_2/lh.brainsurf_outer_skin_surface');
faces = faces + 1; % Use 1-based references for MATLAB; but faces not used here
[alignedVertices, inCap] = alignVertices(mri_data, vertices);
simpleVertices = [
          0 0 0
          0 100 0
          0 0 100
      ];
[alignedSimpleVertices, _] = alignVertices(mri_data, simpleVertices );

R = 1;
A = 2;
S = 3;

axesXY = [[A; R] [A; S] [R; S]];
labels = [['A'; 'R'] ['A'; 'S'] ['R'; 'S']];

for i = 1:3
  figure
  hold on
  axis square
  title(['Plot of y=' labels(1, i) ' vs x = ' labels(2, i)])
  X = axesXY(1, i); Y = axesXY(2, i);
  scatter(vertices(1:1000,X), vertices(1:1000,Y))
  scatter(simpleVertices(:,X), simpleVertices(:,Y), 150, 'markerfacecolor', 'blue')
  scatter(alignedVertices(1:1000,X), alignedVertices(1:1000,Y), 'r')
  scatter(alignedSimpleVertices(:,X), alignedSimpleVertices(:,Y), 150,'markerfacecolor', 'red')
  scatter(alignedVertices(inCap,:)(1:1000,X), alignedVertices(inCap,:)(1:1000,Y), 'markerfacecolor', 'red')
endfor
