function flattenedVertices = flattenSurface(vertices, faces)

% Code for mesh flattening is based on (copied from) the Numerical Tours
% http://www.numerical-tours.com/matlab/meshdeform_3_flattening/
% and Graph toolbox linked there.

% G. Peyr, The Numerical Tours of Signal Processing - Advanced Computational Signal and Image Processing IEEE Computing in Science and Engineering, vol. 13(4), pp. 94-97, 2011.


% 1. Compute the mesh Laplacian matrix.
% Original code commented, in-lined below:
%options.symmetrize = 1;
%options.normalize = 0;
%L = compute_mesh_laplacian(vertices,faces,'conformal',options);
%    |...
%       W = compute_mesh_weight(vertex,face,type,options);


% Compute the conformal weights (cotangent weights). This code was copied, so
% the faces and vertices are transposed and renamed, to fit the original code.
n = max(max(faces));
W = sparse(n,n);
face = faces';
vertex = vertices';
for i=1:3
    i1 = mod(i-1,3)+1;
    i2 = mod(i  ,3)+1;
    i3 = mod(i+1,3)+1;
    pp = vertex(:,face(i2,:)) - vertex(:,face(i1,:));
    qq = vertex(:,face(i3,:)) - vertex(:,face(i1,:));
    % normalize the vectors
    pp = pp ./ repmat( sqrt(sum(pp.^2,1)), [3 1] );
    qq = qq ./ repmat( sqrt(sum(qq.^2,1)), [3 1] );
    % compute angles
    ang = acos(sum(pp.*qq,1));
    W = W + sparse(face(i2,:),face(i3,:),cot(ang),n,n);
    W = W + sparse(face(i3,:),face(i2,:),cot(ang),n,n);
end

% Weight calculation is complete. Now symmetrize the matrix.
% L is symmetric so we don't have to worry about transposing it to match the
% format of our vertices.
L = diag(sum(W,2)) - W;

% 2. Compute the eigenvalues and eigenvectors (from example)

[U,S] = eig(full(L)); S = diag(S);
[S,I] = sort(S,'ascend'); U = U(:,I);

% The vertex positions in 2D are the eigenvectors 2 and 3. 
flattenedVertices = U(:,2:3);

% Use translation / rotation to align the parameterization.

##icenter = 88;
##irotate = 154;
##vertexF = vertexF - repmat(vertexF(:,icenter), [1 n]);
##theta = -pi/2+atan2(vertexF(2,irotate),vertexF(1,irotate));
##vertexF = [vertexF(1,:)*cos(theta)+vertexF(2,:)*sin(theta); ...
##           -vertexF(1,:)*sin(theta)+vertexF(2,:)*cos(theta)];
