
subject = 'FS_0025447_session_2';

addpath matlab

% MATLAB support no Octave..
%m=readtable([subject '\' subject '_layers_structStats_byVertex_allVertices.csv']);
%bms=m.bmIntMean;

% OCTAVE alternative for one of the subjects
bms = textread("FS0025430_bmIntensity.txt");

% No support for gzip in windows matlab -- we decompressed one manually
% mri_data = MRIread([subject '\aseg.nii.gz']);
mri_data = MRIread('extracted/aseg.nii');
[vertices,faces]=read_surf([subject '/lh.brainsurf_outer_skin_surface']);
faces = faces + 1; % Use 1-based references for MATLAB

% Test:Plot BM intensity map for unprocessed vertices (projected onto A/R plane)
figure
plotBmIntensityMap(vertices(:, [2 1]), bms);

[alignedVertices, inCap] = alignVertices(mri_data, vertices);

% Identify faces with any vertex above the chopping plane. The alignVertices
% function returns a flag to determine whether the vertices are above this 
% plane.
%%upCoords = alignedVertices(:, 1);
faceInCap = inCap(faces);
faceHasInCap = any(faceInCap, 2);
capFaces = faces(find(faceHasInCap),:);

% Renumber the vertices and produce list of only vertices in selected faces.
% Not sure if this is necessary.
vertNumbers = sort(unique(capFaces));
filteredVertices = vertices(vertNumbers, :);
bmsFV = bms(vertNumbers);
capFacesFV = lookup(vertNumbers, capFaces);

% Perform flattening (compute intensive)
faVertices = flattenSurface(filteredVertices, capFacesFV);

% Alternative flattening code uses library:
%options.symmetrize = 1;
%options.normalize = 0;
%L = compute_mesh_laplacian(vertices,faces,'conformal',options);
%save('laplacian_default.mat', 'L');
% L_correct = matfile('laplacian_correct.mat').L;
%plot_mesh(faVertices, capFaces);

load 'flattened_vertices.mat'

figure
plotBmIntensityMap(faVertices, bmsFV);



% Test: show the mesh. First plots the flattened mesh using Laplacian method.
% Then an alternative flattening, which is just to discard the superior 
% coordinate and use the R and A values.
%figure
%patch('vertices',faVertices,'faces',capFacesFV, 'edgecolor', 'green');
%figure
%patch('vertices',filteredVertices(:,1:2),'faces',capFacesFV, 'edgecolor', 'blue');
