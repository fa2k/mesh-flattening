
addpath matlab

m = MRIread('extracted/aseg.nii');
m2 = squeeze(m.vol(:,120,:));
subplot(1,2,1);
imagesc(m2);
hold on
axis square
% Find upper part of cerebellum
[y1,x1] = find(m2 == 47);
p1 = find(y1 == min(y1));
x1 = x1(p1(1)); y1=y1(p1(1));
plot(x1, y1, 'r*');
% Find upper part of accumbens
[y2,x2] = find(m2 == 58);
p2 = find(y2 == min(y2));
x2=x2(p2(1)); y2=y2(p2(1));
plot(x2, y2, 'r*');
slope = (y2 - y1) / (x2 - x1);
yL = slope * (1 - x1) + y1

