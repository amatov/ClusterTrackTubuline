function EB3param

% COMPARE HAND-CLICKING TO DETECTION USING LAP
% I = imread(['X:\AlexData\Torsten\xy_resolution\cell1\100x\images\021508_100x#06_t75.tif']);
I = imread(['X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-ns_CLIP170_03\images\080417_RPE1_NZ-ns_CLIP170_03_T000.tif']);
% I = imread(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_01\images\060829_RCC4-CMV93-LMP_01_T000.tif']);


% Y = [50,374, 374, 50, 50]; % Confocal Fig 1
% X = [210, 210, 830, 830, 210]; 

Y = [600,750, 750, 600, 600]; 
X = [550, 550, 700, 700, 550]; % CLIP1

% Y = [250,600, 600, 250, 250]; 
% X = [10, 10, 230, 230, 10]; % WF

% load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\param\feats24400.mat']) %Confocal
% load(['X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-ns_CLIP170_03\cands\feats124.mat']) % CLIP
% load(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_01\cands\feats124.mat']) % WF
% read only withing the square
% im = imread(['X:\AlexData\Torsten\UPLOAD\torsten_noise\original_sd500.tif']);
feats = EB3a(1,1.5 ,3,3,124);

load(['X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-ns_CLIP170_03\images\coordCLIPfeb10-000.mat']);
% load(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_01\images\coordWFfeb10-000.mat']) % WF
% load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\images\coordCLIPfeb10-000.mat']);
% load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\images\coordEB1feb10.mat']);
% load(['X:\AlexData\Torsten\UPLOAD\torsten_noise\coordEB1noise0.mat']);
eb = size(coordEB1,1);

D=createSparseDistanceMatrix(coordEB1,feats.pos,10); % dimentions - leIndx

[links12, links21] = lap(D,-1,0,1);
links = links12(1:eb);

%         If1 = bwmorph(If,'dilate');

%---DEBUG-FIGURE-
figure, imshow(I,[]); % I or im
hold on

h1 = plot(X,Y,'-r'); % RECTANGLE
set(h1,'LineWidth',2)
hold on

h1 = plot(coordEB1(:,1),coordEB1(:,2),'dg'); % GROUND TRUTH
set(h1,'LineWidth',1)
hold on

for i = 1:length(feats.ori)
    h = quiver(feats.pos(i,1),feats.pos(i,2),-cos(feats.ori(i)*pi/180),sin(feats.ori(i)*pi/180),3,'r'); % DETECTION
    set(h,'LineWidth',2)
end

for i = 1:eb
    if links(i) <= size(feats.pos,1)
        h = quiver(coordEB1(i,1),coordEB1(i,2),- coordEB1(i,1) + feats.pos(links(i),1),- coordEB1(i,2) + feats.pos(links(i),2),1,'y'); % ASSOCIATION
        set(h,'LineWidth',2)
    end
end
%---------
matches = length(find(links<=size(feats.pos,1)));

listSq = find(feats.pos(:,2)<Y(2) & feats.pos(:,2)>Y(1) & feats.pos(:,1)<X(3) & feats.pos(:,1)>X(1));
feaSq = length(listSq);

%-DEBUG-FIG-
% fea.pos = [feats.pos(listSq,:)];
% fea.ori = [feats.ori(listSq,:)];
% for i = 1:length(fea.ori)
%     h = quiver(fea.pos(i,1),fea.pos(i,2),-cos(fea.ori(i)*pi/180),sin(fea.ori(i)*pi/180),10,'r'); % DETECTION
%     set(h,'LineWidth',2)
% end
%----------
FalsePositiveProcent = (1-matches/feaSq)*100
FalseNegativeProcent = (1-matches/eb)*100
%--more-figures---
I=double(I);
aux = Gauss2D(I,1); 
I2 = Gauss2D(I,4);  
I3 = aux - I2;
[cutoffInd, cutoffV] = cutFirstHistMode(I3,1); % ZASHTO E RAZLICHNO
% FILTER S1
figure, imshow(aux,[]);
hold on
h1 = plot(X,Y,'-r'); % RECTANGLE
set(h1,'LineWidth',2)
% FILTER S2
figure, imshow(I2,[]);
hold on
h1 = plot(X,Y,'-r'); % RECTANGLE
set(h1,'LineWidth',2)
% SUBSTRACTED IMAGES
figure, imshow(I3,[]);
hold on
h1 = plot(X,Y,'-r'); % RECTANGLE
set(h1,'LineWidth',2)



