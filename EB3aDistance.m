function feats = EB3a(debug,coef,sigma,s,k)

% input debug -> if 0 - save all 'cands' files to disk (k should be #images), 
% else if 1 - run for the k-th image and plot detection figure
% 
% coef = 1; sigma = 4;
% s = 2 if image numbers are XX
% s = 3 if image number are XXX
%
% run:
% EB3a(1,1,4,s,numberOfDebugImage) to plot figure and look at results
% EB3a(0,1,4,s,numberOfLastImage) to run thru whole movie and save detection

[fileName,dirName] = uigetfile('*.tif','Choose a .tif file');
I = imread([dirName,filesep,fileName]);
if debug == 0
    m = 1; %0 claudio
    n = k;
elseif debug == 1
    m = k; 
    n = k;
end
for i = m:n %0:le was m:n
 
%     s =3;%2 some noco & torsten
    strg=sprintf('%%.%dd',s);
    indxStr=sprintf(strg,i);

    I = imread([dirName,fileName(1:end-(s+4)),indxStr,'.tif']); %-6 torsten. -7 otherwise
%         I = imread(['A:\JayNewDropletWork\20160127\07\images\interphase droplets_60x_singles_07_page_0',indxStr,'.tif']); %-6 torsten. -7 otherwise

%         I = imread([dirName,fileName(1:end-(s+10)),indxStr,'c3_ORG.tif']); %-6 DMITRI
    I=double(I);
    aux = Gauss2D(I,1);%1 
    I2 = Gauss2D(I,sigma); %4 (Yukako 10)
    I3 = aux - I2;
%     I3(find(I3<0))=0; % clipping
    [cutoffInd, cutoffV] = cutFirstHistMode(I3,0);

    % coef = 4 Katsu; coef = 1 Claudio; coef = 1 Lisa_xju103_r11; 
    I4 = I3>cutoffV*coef; % REMOVE THE NOISE FEATURES %no 3

    X = bwlabel(I4);
%     warningState = warning;
%     warning off all
%     intwarning off
    stats = regionprops(X,'all'); % Warning: Out of range value converted to intmin('uint8') or intmax('uint8').
%     warning(warningState)

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
        %         Crop(:,:,j) = interp2(I,xGrid,yGrid,'*linear');

        e1 = [];e2 = [];e3 = []; Ori = []; v1 = []; v2 = []; xGrid = []; yGrid = [];
    end

    Cm = nanmean(Crop,3); % MEAN/REPRESENTATIVE EB1 CROP
    Crop(isnan(Crop))=0;% border effect - some NaN
    Cm1 = bwlabel(Cm);
    statsC = regionprops(Cm1,'all');

%     sC = size(Crop);
%     Cm3d = repmat(Cm,[1,1,size(Crop,3)]);
%     dC = Crop - Cm3d;
%     sqC = dC.^2;
%     ssqC = squeeze(sum(sum(sqC,1),2)); %LIST OF DIFFERENCES AFTER SUBTRACTION

    B = Cm(:); % MEAN EB1
    A = ones(length(B),2); 

    for m = 1:size(Crop,3)
        CR = Crop(:,:,m); 
        A(:,2) = CR(:); % INDIVIDUAL EB1
        goodRows = find(A(:,2) ~= 0 & isfinite(B));
        XX = lscov(A(goodRows,:),B(goodRows));
        RES = B(goodRows) - A(goodRows,:)*XX;
        OUT(m,:) = [mean(RES(:).^2),XX'];
    end

    [Ind,V]=cutFirstHistMode(OUT(:,1),0);% switch to 1 to see HIST

    goodFeats = find(OUT(:,1)<(V*1)); % SPOTS WHICH FIT WELL WITH THE MEAN EB1 SPOT

    featNames = fieldnames(feats);
    for field = 1:length(featNames)
        feats.(featNames{field}) = feats.(featNames{field})(goodFeats,:);
    end

    if debug == 1
        
        % find the region of immediate bkgr
%         If1 = bwmorph(If,'dilate');
%         If2 = bwmorph(If1,'dilate');
%         If3 = bwmorph(If2,'dilate');
%         If4 = If3 - If;
%         figure, imshow(If4);
        
        % connected components
        
        % get 1 mean I value for each comet
        
        % get 1 mean I for each bkgr
        
        % calculate average SNR for image
        
        aaux = 5;
%         Ibk = imread('D:\matlab\iPierian\images_not\79363_7007_1.tif');
%         Ibk = double(Ibk);
%         If=Gauss2D(Ibk,1);
        If=Gauss2D(I,1);
        figure, imshow(If(1+aaux:end-aaux,1+aaux:end-aaux),[ ]);%I4 - 0 do 400 zashto??
        title('Scale Space Detection');
        hold on
        NB_FEAT = length(feats.ori)
        Dvec = [];
        for i = 1:length(feats.ori)
            D=createDistanceMatrix([feats.pos(i,:)],[feats.pos]);
            D1 = sort(D);
            Dvec(i) = D1(2);
            Dind = find(D==D1(2));
            h = quiver(feats.pos(i,1)-aaux,feats.pos(i,2)-aaux,-cos(feats.ori(i)*pi/180),sin(feats.ori(i)*pi/180),3,'r');
            set(h,'LineWidth',2)
            h1=quiver(feats.pos(Dind,1)-aaux,feats.pos(Dind,2)-aaux,-cos(feats.ori(Dind)*pi/180),sin(feats.ori(Dind)*pi/180),3,'y');
            set(h1,'LineWidth',2)
        end
% phi = linspace(0,2*pi,50);
%     cosphi = cos(phi);
%     sinphi = sin(phi);
%     
% for k = 1:length(stats) % DONT EXLCLUDE THE SECOND THRESHOLDING YET and does not account for shift / crop 
%         xbar = stats(k).Centroid(1);
%         ybar = stats(k).Centroid(2);
%         e = stats(k).Eccentricity;
%         
%         a = stats(k).MajorAxisLength/2;
%         b = stats(k).MinorAxisLength/2;
%         
%         theta = pi*stats(k).Orientation/180;
%         R = [ cos(theta)   sin(theta)
%             -sin(theta)   cos(theta)];
%         
%         xy = [a*cosphi; b*sinphi];
%         xy = R*xy;
%         
%         x = xy(1,:) + xbar;
%         y = xy(2,:) + ybar;
%         
% 
%             plot(xbar,ybar,'rx','MarkerSize',5,'LineWidth',2);
% 
%         plot(x,y,'r','LineWidth',2);
%     end
%     hold off
        
    elseif debug == 0
        save([dirName(1:end-1),filesep,'cands',filesep,'feats',indxStr],'feats')
        clear goodFeats 
        clear OUT 
        clear V 
        clear Crop
    end
    figure, hist(Dvec)
end


