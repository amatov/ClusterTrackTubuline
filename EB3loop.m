function EB3loop

% loops thru many coef1 and sigma2 and save feat.mat to disc

[fileName,dirName] = uigetfile('*.tif','Choose a .tif file');
I = imread([dirName,filesep,fileName]);
strg=sprintf('%%.%dd',2);
indxStr=sprintf(strg,1);
I = imread([dirName,fileName(1:end-(2+4)),indxStr,'.tif']); %-6 torsten. -7 otherwise
I=double(I);

%-----loop
for coef = 1:0.2:4 % 4*5-3->17
    for sigm = 1.25:0.25:7 % 7*4-5->23
        blobDetection(coef,sigm,I,dirName);
    end
end

%--------------------
function blobDetection(coef,sigm,I,dirName)

strg2=sprintf('%%.%dd',2);
strg3=sprintf('%%.%dd',3);

aux = Gauss2D(I,1);%1
I2 = Gauss2D(I,sigm); %4 (Yukako 10)
I3 = aux - I2;
[cutoffInd, cutoffV] = cutFirstHistMode(I3,0);


I4 = I3>cutoffV*coef; % REMOVE THE NOISE FEATURES %no 3

X = bwlabel(I4);
intwarning off
stats = regionprops(X,'all'); 

% Initialize 'feats' structure
feats=struct(...
    'pos',[0 0],...                  % Centroid - [y x]
    'ecc',0,...                      % Eccentricity
    'ori',0);   % Orientation

for j = 1:length(stats)
    feats.pos(j,1) = stats(j).Centroid(1);
    feats.pos(j,2) = stats(j).Centroid(2);
    feats.ecc(j,1) = stats(j).Eccentricity;
    feats.ori(j,1) = stats(j).Orientation;
    feats.len(j,1) = stats(j).MajorAxisLength;

    e1 = [-cos(stats(j).Orientation*pi/180) sin(stats(j).Orientation*pi/180) 0];
    e2 = [sin(stats(j).Orientation*pi/180) cos(stats(j).Orientation*pi/180) 0];
    e3 = [0 0 1];
    Ori = [stats(j).Centroid  0];
    v1 = [-10 10];
    v2 = [-5 5];
    v3 = [0 0];
    [xGrid,yGrid]=arbitraryGrid(e1,e2,e3,Ori,v1,v2,v3);

    Crop(:,:,j) = interp2(I,xGrid,yGrid);

    e1 = [];e2 = [];e3 = []; Ori = []; v1 = []; v2 = []; xGrid = []; yGrid = [];
end

Cm = nanmean(Crop,3); % MEAN/REPRESENTATIVE EB1 CROP
Crop(isnan(Crop))=0;% border effect - some NaN
Cm1 = bwlabel(Cm);
statsC = regionprops(Cm1,'all');

sC = size(Crop);
Cm3d = repmat(Cm,[1,1,size(Crop,3)]);
dC = Crop - Cm3d;
sqC = dC.^2;
ssqC = squeeze(sum(sum(sqC,1),2)); %LIST OF DIFFERENCES AFTER SUBTRACTION

B = Cm(:);
A = ones(length(B),2);

for m = 1:size(Crop,3)
    CR = Crop(:,:,m);
    A(:,2) = CR(:);
    goodRows = find(A(:,2) ~= 0 & isfinite(B));
    XX = lscov(A(goodRows,:),B(goodRows));
    RES = B(goodRows) - A(goodRows,:)*XX;
    OUT(m,:) = [mean(RES(:).^2),XX'];
end

[Ind,V]=cutFirstHistMode(OUT(:,1),0);% switch to 1 to see HIST

goodFeats = find(OUT(:,1)<V); % SPOTS WHICH FIT WELL WITH THE MEAN EB1 SPOT

featNames = fieldnames(feats);
for field = 1:length(featNames)
    feats.(featNames{field}) = feats.(featNames{field})(goodFeats,:);
end

save([dirName(1:end-7),'param',filesep,'feats',sprintf(strg2,round(coef*10)),sprintf(strg3,sigm*100)],'feats')
clear goodFeats
clear OUT
clear V
clear Crop



