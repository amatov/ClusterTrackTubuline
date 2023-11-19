function getPoints

[fileName,dirName] = uigetfile('*.tif','Choose a .tif file');
I = imread([dirName,filesep,fileName]);

% load([dirName(1:end-7),filesep,'coordEB1.mat'])

aux = 50

Y = [600,750, 750, 600, 600]; 
X = [550, 550, 700, 700, 550]; % CLIP1

% Y = [50,374, 374, 50, 50]; 
% X = [210, 210, 830, 830, 210]; % Confocal 

% Y = [250,600, 600, 250, 250]; 
% X = [10, 10, 230, 230, 10]; % WF

figure, imshow(I,[]);
hold on
h = plot(X,Y,'-r')
set(h,'LineWidth',2)

[XX,YY] = getpts%ginput
nbEB1 = length(XX)

% aaux = 5;
% If=Gauss2D(I,1);
% figure, imshow(I,[]);%I4
hold on

    h1 = plot(XX,YY,'dg');
%     h1 = plot(coordEB1(:,1),coordEB1(:,2),'dg');
    set(h1,'LineWidth',1)

coordEB1 = [XX,YY];
save([dirName,filesep,'coordCLIPfeb10-124'],'coordEB1')
% save([dirName,filesep,'coordWFfeb10-000'],'coordEB1')