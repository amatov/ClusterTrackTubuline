function reformatGrouping

% I = imread(['X:\AlexData11\786Opar\786Opar_NaCl01_R3D\images\786Opar_NaCl01_T000.tif']);
load(['X:\AlexData11\786Opar\786Opar_NaCl02_R3D\point_files\config001_5p00_track_bidir.mat']);
% load(['Z:\AlexResults\EB1_Katsu_1s_1_600\point_files\EB1_poster_pooledData.mat']);

% find all the trajectories with lifetimes > 4
indx = find( [tracks.len] >= 4); %4
traj = tracks(indx);
leIndx = length(indx);

for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
end

minFrB = min([traj.startID])
maxFrE = max([traj.endID])
aux = minFrB - 1; % Displacement of first track w a beginning

leIndBB = length(unique([traj.startID])) % FIND HOW MANY unique FRAMES HAVE START-ID
%--------------------------------------------------------------------------
for i = 1:leIndBB % Fill In Frame by Frame starting w the Beginnings

    % Initialize 'feats' structure
    feats=struct(...
    'pos',[0 0],...                  % Centroid - [y x]
    'ecc',0,...                      % Eccentricity
    'ori',0,...   % Orientation
    'tip',0);       % Beginning or End

    s = 3;
    strg=sprintf('%%.%dd',s);
    indxStr=sprintf(strg,(i-1)); % NUMBER OF FRAME

    indB = find([traj.startID]==(aux+i)); % Take into account the shift
    indE = find([traj.endID]==(aux+i));
    leIndB = length(indB);
    leIndE = length(indE);

    for j = 1:leIndB % Fill in feats beginning in frame 'i'

        dY = traj(indB(j)).points(end,1) - traj(indB(j)).points(1,1);
        dX = traj(indB(j)).points(end,2) - traj(indB(j)).points(1,2);

        feats.pos(j,1) = traj(indB(j)).points(1,1); % Y of Begin point
        feats.pos(j,2) = traj(indB(j)).points(1,2); % X of Begin point
        feats.ecc(j,1) = sqrt(dY*dY + dX*dX);
        if dX == 0
            dX = dX + 0.0001;
        end
        feats.ori(j,1) = atan(dY/dX); % Xe-X1,Ye-Y1
        feats.tip(j,1) = 1; % Beginning stamp
        
        dY = [];
        dX = [];
    end
    for j = 1:leIndE % Fill in feats ending in frame 'i'

        dY = traj(indE(j)).points(end,1) - traj(indE(j)).points(1,1);
        dX = traj(indE(j)).points(end,2) - traj(indE(j)).points(1,2);

        feats.pos(j+leIndB,1) = traj(indE(j)).points(end,1); % Y of End point
        feats.pos(j+leIndB,2) = traj(indE(j)).points(end,2); % X of End point
        feats.ecc(j+leIndB,1) = sqrt(dY*dY + dX*dX);
        if dX == 0
            dX = dX + 0.0001;
        end
        feats.ori(j+leIndB,1) = atan(dY/dX); % Xe-X1,Ye-Y1
        feats.tip(j+leIndB,1) = 2; % End stamp
        
        dY = [];
        dX = [];
    end
    
    fprintf('Total number of EB1 features is %d in frame %d\n', length(feats.pos), i); % CHECK
    
    save(['H:\GROUPING_TEST\cands\feats',indxStr],'feats')

    indB = [];
    indE = [];
    leIndB = [];
    leIndE = [];
end
%--------------------------------------------------------------------------
for i = (leIndBB+1):maxFrE % Frame by Frame continuining for the rest of the Ends

    % Initialize 'feats' structure
    feats=struct(...
    'pos',[0 0],...                  % Centroid - [y x]
    'ecc',0,...                      % Eccentricity
    'ori',0,...   % Orientation
    'tip',0);       % Beginning or End

    s = 3;
    strg=sprintf('%%.%dd',s);
    indxStr=sprintf(strg,(i-1)); % NUMBER OF FRAME

    indEE = find([traj.endID]==(aux+i)); % Take into account the shift
    leIndEE = length(indEE);

    for j = 1:leIndEE % Fill in feats ending in frame 'i'

        dY = traj(indEE(j)).points(end,1) - traj(indEE(j)).points(1,1);
        dX = traj(indEE(j)).points(end,2) - traj(indEE(j)).points(1,2);

        feats.pos(j,1) = traj(indEE(j)).points(end,1); % Y of End point
        feats.pos(j,2) = traj(indEE(j)).points(end,2); % X of End point
        feats.ecc(j,1) = sqrt(dY*dY + dX*dX);
        if dX == 0
            dX = dX + 0.0001;
        end
        feats.ori(j,1) = atan(dY/dX); % Xe-X1,Ye-Y1
        feats.tip(j,1) = 2; % End stamp
        
        dY = [];
        dX = [];
    end
    
    fprintf('Total number of EB1 features is %d in frame %d\n', length(feats.pos), i); % CHECK
    
    save(['H:\GROUPING_TEST\cands\feats',indxStr],'feats')
    
    indEE = [];
    leIndEE = [];
end