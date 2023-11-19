function h = plotGroupTwoColorTorsten 

minLT = 4;
I = imread(['X:\AlexData\Torsten\trackingValidation\EB1\images\020_crop_c1t01.tif']);
fileName = '020_crop_c1t01.tif';
dirName = 'X:\AlexData\Torsten\trackingValidation\EB1\images\';
load([dirName(1:end-8),'\point_files\config001_4p00_track_bidir.mat']); %5
load([dirName(1:end-8),'\groups\group.mat']);
traj=tracks(find([tracks.len]>=minLT));
leIndx = length(traj);
% calculate trajectory information
for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
    dY = traj(i).points(end,1) - traj(i).points(1,1);
    dX = traj(i).points(end,2) - traj(i).points(1,2);
    traj(i).vec = [dX; dY];
    traj(i).vel = sqrt(dY^2+dX^2)/traj(i).len;
end
traj = traj(find([traj.vel]>0)); % SOME DONT MOVE!?

leT = length(traj);
leG1 = length(group);
pixelSize = 0.107; %0.11; % (microns)
samplingRate = 0.62; %0.39 all but EB1+MTs -
scaleFactor = pixelSize * 60 / samplingRate ;

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
%     gapsInSegment(i) = (g); % g is the number of gaps for i-th group
end
%--------------------------------------------------------------------------
grNb = length(group);

h = figure,imshow(I,[])
hold on
% h = figure;
for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
        plot(traj(k(1)).points(1,1),traj(k(1)).points(1,2),'go')
        hold on
        for j = 1:le_gr
            plot(traj(k(j)).points(:,1),traj(k(j)).points(:,2),'g-')
            plot(traj(k(j)).points(end,1),traj(k(j)).points(end,2),'g*')
            plot([traj(k(j)).points(1,1),traj(k(j)).points(end,1)],[traj(k(j)).points(1,2),traj(k(j)).points(end,2)],'g--')
            if j < le_gr
                if group(i).direction(j) == 1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'b-')
                    plot(traj(k(j+1)).points(1,1),traj(k(j+1)).points(1,2),'b*')
                elseif group(i).direction(j) == -1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'r-')
                    plot(traj(k(j+1)).points(1,1),traj(k(j+1)).points(1,2),'r*')
                end
            end
        end
    end
end
hold off
% disp(sprintf('Number of groups %d',grNb));
%--------------------------------------------------------------------------
% Initialize 'growth' structure
growth=struct(...
    'list',[],...                  % track list
    'group',0);   % group number
    
k = 1;
for i = 1:leG % for all groups
    leGi = length([group(i).list]);
    
    if length(growth(k).list) > 0
        k = k + 1;
    end
    for j = 1:(leGi-1) % for all member-tracks of a group
              
        if group(i).direction(j) == 1 
            
%            growth(k).list = [growth(k).list(1:end-1),j,j+1]; % BUG 
           growth(k).list = [growth(k).list,j,j+1];
           % ako se povtariat list  = unique([growth(1).list])
           growth(k).group = i;
           growth(k+1).list = [];
           
        elseif group(i).direction(j) == -1 && j > 1 && group(i).direction(j-1) == 1 && j+1<leGi && group(i).direction(j+1) == 1
            k = k + 1; 
        end
    end
end
growth = growth(1:end-1); % get rid of the last one (empty)
leGrowth = length(growth);
for i = 1:leGrowth
    growth(i).list = unique([growth(i).list]);
end
%-----------------------------------------------------------
group_list = [group.list];
group_list = sort(group_list);
indx_notG = 0;
delta_T_notG = [];
for i = 1:leT
    if ~ismember(group_list,i)
        indx_notG = indx_notG + 1;
        delta_T_notG(indx_notG) = traj(i).len;
    end
end
% %-----------
hold on
%--------------------------------------------------------------------------
% group(growth(1).group).list(growth(1).list)
delta_T_gr = [];
speedGrowth = [];
percentGap = [];
gap_time = [];
gap_aux = [];

for i = 1:leGrowth
    indx_gr = growth(i).group;
    indx_first = growth(i).list(1);
    indx_last = growth(i).list(end);

    dy = traj(group(indx_gr).list(indx_first)).points(1,1) - traj(group(indx_gr).list(indx_last)).points(end,1); % link
    dx = traj(group(indx_gr).list(indx_first)).points(1,2) - traj(group(indx_gr).list(indx_last)).points(end,2);
    
    plot([traj(group(indx_gr).list(indx_last)).points(end,1),traj(group(indx_gr).list(indx_first)).points(1,1)],[traj(group(indx_gr).list(indx_last)).points(end,2),traj(group(indx_gr).list(indx_first)).points(1,2)],'b:')
    
    aVec = ([dx; dy])';
    magAvec = sqrt(sum(aVec.^2,2));

    delta_T_gr(i) = traj(group(indx_gr).list(indx_last)).startID+traj(group(indx_gr).list(indx_last)).len - traj(group(indx_gr).list(indx_first)).startID;
    speedGrowth(i) = magAvec / delta_T_gr(i) * scaleFactor;
    
    for j = 1:(length([growth(i).list])-1)
        gap_aux(j) = traj(group(growth(i).group).list(j+1)).startID - traj(group(growth(i).group).list(j)).endID - 1;
    end
    gap_time(i) = sum(gap_aux);
    percentGap(i) = gap_time(i)/delta_T_gr(i);%RATIOS
    gap_aux = [];
end

