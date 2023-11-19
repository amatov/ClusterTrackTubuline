function getPointsTorsten

[fileName,dirName] = uigetfile('*.tif','Choose a .tif file');
I = imread([dirName,filesep,fileName]);

Y = [50,374, 374, 50, 50];%[130,374, 374, 130, 130];
X = [210, 210, 830, 830, 210];%[510, 510, 830, 830, 510];

load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\param\feats24400.mat'])

figure, imshow(I,[]);
hold on

h = plot(X,Y,'-r');
set(h,'LineWidth',2)
hold on

for i = 1:length(feats.ori)
    h = quiver(feats.pos(i,1),feats.pos(i,2),-cos(feats.ori(i)*pi/180),sin(feats.ori(i)*pi/180),3,'r');
    set(h,'LineWidth',2)
end

%---
% [XX,YY] = getpts;%ginput
load([dirName(1:end-7),filesep,'coordEB1may2009.mat'])
XX = coordEB1(:,1);
YY = coordEB1(:,2);
%---

nbEB1 = length(XX)
hold on

h1 = plot(XX,YY,'dg');
set(h1,'LineWidth',1)

%---
% coordEB1 = [XX,YY];
% save([dirName(1:end-7),'coordEB1may2009'],'coordEB1-noise050')