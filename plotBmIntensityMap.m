function plotBmIntensityMap(vertices, bms)

% Plots a heat-map of mean bone marrow intensity as a function of 
% two-dimensional coordinates in vertices. Vertices should be an Nx2 matrix.

maxs = max(vertices);
mins = min(vertices);
ranges = maxs - mins;

BINS = 50;
intensitySums = zeros(BINS, BINS);
counts = ones(BINS, BINS);

for i=1:length(vertices)
  xypoint = vertices(i, :);
  bins = round((xypoint - mins) * (BINS-1) ./ ranges) + 1;
  intensitySums(bins(1), bins(2)) += bms(i);
  counts(bins(1), bins(2)) += 1;
endfor

normIntensities = intensitySums ./ counts;

maxIntensity = max(max(normIntensities))

imshow(normIntensities, [0 maxIntensity], 'colormap', colormap('jet'));

% HIST3:  pkg load statistics
% Test:  hist3(vertices)