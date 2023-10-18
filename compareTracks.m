function compareTracks

minLT = 4;

I = imread(['X:\AlexData\Torsten\trackingValidation\EB1\images\EB1\020_crop_c1t01.tif']);
% ground truth
tor = xlsread('X:\AlexData\Torsten\trackingValidation\tracking_data2.xls');
% cf = [0;find(isnan(tor(:,1)));1622]; % find the break between tracks
% col 2 = frame, col 4 = x, col 5 = y
% plot(tor(cf(i)+1:cf(i+1)-1,3),tor(cf(i)+1:cf(i+1)-1,4),colors(i))
%-------------------------------
dirName = 'X:\AlexData\Torsten\trackingValidation\';
I = imread([dirName,'EB1\images\EB1\020_crop_c1t01.tif']);

load([dirName,'EB1\point_files\config001_4p00_track_bidir.mat']); %torsten
load([dirName,'EB1\group45-60\group.mat']); %torsten
% load([dirName,'EB1\groups\parser.mat']); %torsten
%-----------
cf = [0;find(isnan(tor(:,1)));1434]; % 1622- find the break between tracks
% col 1 = frame, col 3 = x, col 4 = y
colors = ['m', 'c', 'r', 'g', 'y', 'm', 'c', 'r', 'g', 'b', 'm', 'c', 'r', 'g', 'y', 'm', 'c', 'b', 'b' ,'r','g'];

figure,imshow(I,[])
hold on
for i = 1:length(cf)-1 % number tracks
        
        plot(tor(cf(i)+1:cf(i+1)-1,4),tor(cf(i)+1:cf(i+1)-1,5),colors(i))
        
        hold on
        
end
% RES (for groups but also ungrouped track ends -> CAT)
% +- 2 frames, +-2pixels
RES = find(tor(:,8)==5);
for i = 1:length(RES)
    plot(tor(RES(i),4),tor(RES(i),5),'r*')
end
title('RESCUE')
%--------------CAT---------------
figure,imshow(I,[])
hold on
for i = 1:length(cf)-1 % number tracks
        
        plot(tor(cf(i)+1:cf(i+1)-1,4),tor(cf(i)+1:cf(i+1)-1,5),colors(i))
        
        hold on
        
end
% CAT (for groups but also ungrouped track ends -> CAT)
% +- 2 frames, +-2pixels
CAT = find(tor(:,8)==4);
for i = 1:length(RES)
    plot(tor(CAT(i),4),tor(CAT(i),5),'w*')
end
title('CARASTROPHE')
%------------------------------

list = [];
figure,imshow(I,[])
hold on
for i = 1:length(cf)-1 % number tracks
        
        list = find(tor(:,1)==i & tor(:,7)==1);% only growth now
        
        h = plot(tor(list,4),tor(list,5),'*');
        set(h,'Color',colors(i))
        hold on
        
end
title('GROWTH')
traj=tracks(find([tracks.len]>=minLT));
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
k = zeros(leT,1);
for i = 1:leT
   
    % check for all tracks if there is a match in handtracked within 2p
    % y x - for each coordinate look for handtracked in the corresponding
    % frame - listed in 2nd column in .xls
    for j = 1:size(traj(i).points,1)
        frame = traj(i).startID + j - 1;
        indx = find(tor(:,2)==frame & tor(:,7)==1); % find which handclicked are in the same frame and represent growth i.e. flag 1
        B(:,1)=tor(indx,4);% y
        B(:,2)=tor(indx,5);% x SWITCH
        E(1,1) = traj(i).points(j,1); % check for this entry if there is handtracked
        E(1,2) = traj(i).points(j,2);
        D=createSparseDistanceMatrix(E,B,4); % y x
        if length(find(D))>0
            hold on 
            plot(traj(i).points(:,1),traj(i).points(:,2),'w.-')
            k(i) = k(i) + 1;
            f(i) = frame;
%             t(i) = indx(find(D,1));
        end
        D = [];
        B = [];
        E = [];
    end
end
% --------END GROWTH
 leG1 = length(group);
pixelSize = 0.107;%0.107; %0.11; % (microns)
samplingRate = 0.62; %0.39 all but EB1+MTs(0.62) - Noco 1- if not -> 0.5; % (seconds)
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
end
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
           growth(k).list = [growth(k).list,j,j+1];
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
I = imread(['X:\AlexData\Torsten\trackingValidation\EB1\images\EB1\020_crop_c1t01.tif']);
h = figure,imshow(I,[])
hold on
list = [];
for i = 1:length(cf)-1 % number tracks
        
        list = find(tor(:,1)==i & tor(:,7)==3);% shrink
        
        h = plot(tor(list,4),tor(list,5),'*');
        set(h,'Color',colors(i))
        hold on
        
end
title('SHRINK')
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
    
%     plot([traj(group(indx_gr).list(indx_last)).points(end,2),traj(group(indx_gr).list(indx_first)).points(1,2)],[traj(group(indx_gr).list(indx_last)).points(end,1),traj(group(indx_gr).list(indx_first)).points(1,1)],'b:')
    
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
grNb = length(group);

for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
        for j = 1:le_gr
            if j < le_gr
                    if group(i).direction(j) == -1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'r-')
                end
            end
        end
    end
end
hold off
%--- END SHRINK---------
I = imread(['X:\AlexData\Torsten\trackingValidation\EB1\images\EB1\020_crop_c1t01.tif']);
h = figure,imshow(I,[])
hold on
list = [];
for i = 1:length(cf)-1 % number tracks
        
        list = find(tor(:,1)==i & tor(:,7)==2);% pause
        
        h = plot(tor(list,4),tor(list,5),'*');
        set(h,'Color',colors(i))
        hold on
        
end
title('PAUSE')
for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
        for j = 1:le_gr
            if j < le_gr
                if group(i).direction(j) == 1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'b-')
                end
            end
        end
    end
end
hold off
%--- END PAUSE---------
plotGroupTwoColorBench(traj,group);
% readout groups
for i = 1:19
    
  while tor(1,:) == i
  end
 end
% check if PAUSES
% my pause has a widow (xi,yi->) frame 1 til 5
% see if one of his overlaps

% SHRINKS
% my shrink has a widow (xi,yi->) frame 1 til 5
% see if one of his overlaps




    
 