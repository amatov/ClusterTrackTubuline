function cutGaps


dirName = 'X:\AlexData\Torsten\111607_EB1andMTs\111607_#20\';
% I = imread([dirName,'EB1\images\EB_01.tif']);

load([dirName,'EB1\point_files\config001_6p50_track_bidir.mat']); %torsten
load([dirName,'EB1\groups\group.mat']); %torsten CHANGE TO 15-15

pixelSize = 0.107;%0.107(microns)
samplingRate = 0.62; %0.39 all but EB1+MTs(0.62) 
scaleFactor = pixelSize * 60 / samplingRate ;

traj=tracks(find([tracks.len]>=4));
leIndx = length(traj);
% calculate trajectory information
for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
    dY = traj(i).points(end,1) - traj(i).points(1,1);
    dX = traj(i).points(end,2) - traj(i).points(1,2);% Y X
    traj(i).vec = [dX; dY];
    traj(i).vel = sqrt(dY^2+dX^2)/traj(i).len;
end
traj = traj(find([traj.vel]>0)); % SOME DONT MOVE!?

leT = length(traj);
leG1 = length(group);
indxFullGr = [];
for i = 1:leG1 % for all groups
    leGi = length([group(i).list]); 
    % more than zero tracks in that group (some groups are empty due to appending during grouping)
    if leGi > 0 
        indxFullGr = [indxFullGr,i]; % BUG
    end
end
group = group(indxFullGr);
gg = 0; ss = 0; piecesInSegment = [];
leG = length(group);
for i = 1:leG % for all groups
    leGi = length([group(i).list]);
    g = 0; s = 0; 
    for j = 1:(leGi-1) % for all member-tracks of a group

        dy = traj(group(i).list(j+1)).points(1,1) - traj(group(i).list(j)).points(end,1); % link
        dx = traj(group(i).list(j+1)).points(1,2) - traj(group(i).list(j)).points(end,2);
        aVec = ([dx; dy])';
        magAvec = sqrt(sum(aVec.^2,2));

        dY = traj(group(i).list(j)).points(end,1) - traj(group(i).list(j)).points(1,1); % track
        dX = traj(group(i).list(j)).points(end,2) - traj(group(i).list(j)).points(1,2);
        traj_vec = [dX; dY];
        magTrajVec = sqrt(sum(traj_vec.^2,1));

        cos_ang = (aVec*traj_vec)./(magAvec*magTrajVec);
        if cos_ang > 0 % growth
            g = g + 1; % local counted
            gg = gg + 1; % global counter
            group(i).direction(j) = 1; % forward
            delta_T_gr_GAP(gg) = traj(group(i).list(j+1)).startID-traj(group(i).list(j)).startID-traj(group(i).list(j)).len+1;
            group(i).meanGrowth_GAP(g) = magAvec/delta_T_gr_GAP(gg);
            speedGrowth_GAP(gg) = group(i).meanGrowth_GAP(g)*scaleFactor;
        end
        if cos_ang < 0 % shrinkage % RATIOS
            s = s + 1; % local counter 
            ss = ss + 1; % global counter
            group(i).direction(j) = -1; % backward
            delta_T_sh(ss) = traj(group(i).list(j+1)).startID-traj(group(i).list(j)).startID-traj(group(i).list(j)).len+1;
            group(i).meanShrink(s) = magAvec/delta_T_sh(ss);
            speedShrink(ss) = group(i).meanShrink(s)*scaleFactor;
        end
    end
end
g = 0;
grNb = length(group);
for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
        hold on
        for j = 1:le_gr

            if j < le_gr
                if group(i).direction(j) == 1%GAP
                    g = g+1;
                    gap(g).points(1,1) = traj(k(j)).points(end,1); % end of track before gap Y
                    gap(g).points(2,1) = traj(k(j+1)).points(1,1); % beginning of track after gap Y
                    gap(g).points(1,2) = traj(k(j)).points(end,2); % end of track before gap X
                    gap(g).points(2,2) = traj(k(j+1)).points(1,2); % beginning of track after gap X
                    gap(g).len = traj(k(j+1)).startID - traj(k(j)).startID - traj(k(j)).len + 1;
                    dY = gap(g).points(2,1) - traj(i).points(1,1);
                    dX = gap(g).points(2,2) - traj(i).points(1,2);
                    gap(g).vec = [dX; dY];
                    gap(g).vel = sqrt(dY^2+dX^2)/gap(g).len*scaleFactor;
                end
            end
        end
    end
end
grNb = length(group);
% 
% for i = 1:grNb
%     delta_t(i) = traj(group(i).list(end)).endID - traj(group(i).list(1)).startID + 1; 
% end

GAP_TIME_sec = mean(delta_T_gr_GAP)*0.62
GAP_SPEED_mu = mean(speedGrowth_GAP)

[cutoffInd, cutoffV] = cutFirstHistMode(speedGrowth_GAP,1);

CUTOFF_SPEED = cutoffV
coef = 1;
indx = find(speedGrowth_GAP<cutoffV*coef);

gap_s_corr = speedGrowth_GAP(indx);
gap_t_corr = delta_T_gr_GAP(indx);

GAP_Sp_corr = mean(gap_s_corr) 
GAP_Ti_corr = mean(gap_t_corr)*0.62

a



