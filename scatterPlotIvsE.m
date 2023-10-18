function scatterPlotIvsE

% dirName = 'X:\AlexData\Torsten\xy_resolution\cell1\100x\';
dirName = '/mnt/alex10/AlexData/Torsten/xy_resolution/cell1/100x/';

% I = imread(['X:\AlexData\Torsten\xy_resolution\cell1\100x\images\021508_100x#06_t01.tif']); %-6 torsten. -7 otherwise
% I=double(I);
% aux = Gauss2D(I,1);%1
% I2 = Gauss2D(I,4);
% I3 = aux - I2;
% [cutoffInd, cutoffV] = cutFirstHistMode(I3,0);
%
% I4 = I3>cutoffV*2.4; % REMOVE THE NOISE FEATURES %no 3
%
% X = bwlabel(I4);
% intwarning off
% stats = regionprops(X,'all');
%
% % Initialize 'feats' structure
% feats=struct(...
%     'pos',[0 0],...                  % Centroid - [y x]
%     'ecc',0,...                      % Eccentricity
%     'ori',0,...% Orientation
%     'max',0);
%
% figure, imshow(I,[])
% for j = 1:length(stats)
%     feats.pos(j,1) = stats(j).Centroid(1);
%     feats.pos(j,2) = stats(j).Centroid(2);
%     feats.ecc(j,1) = stats(j).Eccentricity;
%     feats.ori(j,1) = stats(j).Orientation;
%     feats.len(j,1) = stats(j).MajorAxisLength;
%
%
%     idx = stats(j).PixelIdxList;
%     pixel_values = I(idx);
%     max_int = max(pixel_values);
%     aa = find(pixel_values==max_int);
%
%     x = stats(j).PixelList(aa, 1);
%     y = stats(j).PixelList(aa, 2);
%
%     hold on
%     plot(x,y, 'r*')
%
%     feats.max(j,1) = max_int; % FIND MAX INTENSITY PER BLOB
%
% end

load([dirName,'point_files',filesep,'config001_4p00_track_bidir.mat']);


x1 = []; x2 = []; y1 = []; y2 = [];
traj = tracks(find([tracks.len]>=4)); % only long ones

n = 0;
leIndx = length(traj);

for i = 1:leIndx % number of images
    x = []; y = [];

    traj(i).endID = traj(i).startID + traj(i).len - 1;
    %-------------------------IMAGE LOOP
    for k = 1:traj(i).len % for all images this track goes thru

        strg=sprintf('%%.%dd',2);
        indxStr=sprintf(strg,(k+traj(i).startID-1));

        I = imread(['/mnt/alex10/AlexData/Torsten/xy_resolution/cell1/100x/images/021508_100x#06_t',indxStr,'.tif']); %-6 torsten. -7 otherwise
        I=double(I);
        aux = Gauss2D(I,1);%1
        I2 = Gauss2D(I,4);
        I3 = aux - I2;
        [cutoffInd, cutoffV] = cutFirstHistMode(I3,0);

        I4 = I3>cutoffV*2.4; % REMOVE THE NOISE FEATURES %no 3

        X = bwlabel(I4);
        intwarning off
        stats = regionprops(X,'all');

        % Initialize 'feats' structure
        feats=struct(...
            'pos',[0 0],...                  % Centroid - [y x]
            'ecc',0,...                      % Eccentricity
            'ori',0,...% Orientation
            'max',0);

        %     figure, imshow(I,[])
        %----------------------------------------------------------
        for j = 1:length(stats) % for all comets - get the max INT
            feats.pos(j,1) = stats(j).Centroid(1);
            feats.pos(j,2) = stats(j).Centroid(2);
            feats.ecc(j,1) = stats(j).Eccentricity;
            feats.ori(j,1) = stats(j).Orientation;
            feats.len(j,1) = stats(j).MajorAxisLength;


            idx = stats(j).PixelIdxList;
            pixel_values = I(idx);
            max_int = max(pixel_values);
            aa = find(pixel_values==max_int);

            %             x = stats(j).PixelList(aa, 1);
            %             y = stats(j).PixelList(aa, 2);

            %         hold on
            %         plot(x,y, 'r*')

            feats.max(j,1) = max_int; % FIND MAX INTENSITY PER BLOB

        end
        %--------------------------------------------------------------
        %     load([dirName,'cands',filesep,'feats',indxStr,'.mat']);
        y = feats.pos(:,1);
        x = feats.pos(:,2);



        aux1 = []; aux2 = [];

        if k > 1
            vel_aux = 60*0.0642/0.39* sqrt( (traj(i).points(k,1)-traj(i).points(k-1,1))^2 +  (traj(i).points(k,2)-traj(i).points(k-1,2))^2 );
        else
            vel_aux = 60*0.0642/0.39* sqrt( (traj(i).points(k,1)-traj(i).points(k+1,1))^2 +  (traj(i).points(k,2)-traj(i).points(k+1,2))^2 );
        end

        aux1 = find(y == traj(i).points(k,1));
        aux2 = find(x == traj(i).points(k,2));
        %------------------------------------------------
        if ~isempty(aux1) && ~isempty(aux2)
            if (aux1(1) == aux2(1))
                if (feats.ecc(aux1)>0)
                    n = n+1;
                    ecc(n) = feats.ecc(aux1(1));
                    int(n) = feats.max(aux1(1));
                    vel(n) = vel_aux;
                end
            end
        end
        %-----------------------------------------------
    end
end


% figure, plot(vel,int,'b.')
figure, scatter(vel,int,3,ecc)
figure, scatter(ecc,vel)
% figure, plot(feats.max,feats.ecc,'b.')
xlim([0 25])
