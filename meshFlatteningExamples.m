% Mesh Flattening

% http://www.numerical-tours.com/matlab/meshdeform_3_flattening/

getd = @(p)path(p,path);

getd('toolbox_signal/');
getd('toolbox_general/');
getd('toolbox_graph/');

% First load a mesh.

name = 'nefertiti';
options.name = name;
[vertex,faces] = read_mesh(name);
n = size(vertex,2);

% Format of vertex, faces:
%  vertex: a list of points in 3D-space (each point three coordinates)
%  faces:  3-tuples pointing to indexes of three vertices, to indicate 
%          a triangular face in 3D. So the face is defined by three
%          numbers, which are indexes into the vertex array.

% Display it.

clf;
plot_mesh(vertex,faces, options);
shading faceted;

% Compute the mesh Laplacian matrix.

options.symmetrize = 1;
options.normalize = 0;
L = compute_mesh_laplacian(vertex,faces,'conformal',options);

% Compute the eigenvalues and eigenvectors

[U,S] = eig(full(L)); S = diag(S);
[S,I] = sort(S,'ascend'); U = U(:,I);

% The vertex positions are the eigenvectors 2 and 3.

vertexF = U(:,2:3)';

% Use translation / rotation to align the parameterization.

icenter = 88;
irotate = 154;
vertexF = vertexF - repmat(vertexF(:,icenter), [1 n]);
theta = -pi/2+atan2(vertexF(2,irotate),vertexF(1,irotate));
vertexF = [vertexF(1,:)*cos(theta)+vertexF(2,:)*sin(theta); ...
           -vertexF(1,:)*sin(theta)+vertexF(2,:)*cos(theta)];

% Display the flattened mesh.

clf;
plot_mesh(vertexF,faces);



