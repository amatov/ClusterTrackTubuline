function [parser,percentTracksGrouped,gapsInSegment,probShrink,percentTimeShrink]= parseGroupsRegions(traj,group)

minLT = 4;
leT = length(traj);
leG1 = length(group);
pixelSize = 0.06; %  (microns)
samplingRate = 0.4; %   % (seconds)
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
% plotGroupTwoColor(traj,group);
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
% h = plotGroupTwoColor(traj,group);
% hold on
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
%-----------------
for i = 1 : leT
    d = diff(traj(i).points(:, 1:2));
    traj(i).meanDisp = sum(sqrt(sum(d.^2, 2)))/(traj(i).len-1)*scaleFactor ;
end
traj_meanDisp = [traj.meanDisp];
% delta_T_groups_notG = cat(2,delta_T_gr,delta_T_notG);
speedShrink_minLT4 = speedShrink(find(delta_T_sh>=minLT));
speedShrink_maxLT3 = speedShrink(find(delta_T_sh<minLT));
speedGrowth_GAP_minLT4 = speedGrowth_GAP(find(delta_T_gr_GAP>=minLT));
speedGrowth_GAP_maxLT3 = speedGrowth_GAP(find(delta_T_gr_GAP<minLT));
%-------------------------------------------------------------------------
% h = plotGroupTwoColor(traj,group);
% colorCodedPlot(group);
% saveas(h,([dirName(1:end-8),filesep,'groups',filesep,'grouping_figure','.fig']),'fig');
% close 
% Initialize 'growth' structure
parser=struct(...
    'growth_speeds_tracks',[],...      
    'growth_speeds_gaps',[],...   
    'growth_speeds_groups',[],...   
    'growth_speeds_gaps_minLT4',[],...   
    'growth_speeds_gaps_maxLT3',[],...  
    'growth_times_tracks',[],...
    'growth_times_groups',[],...   
    'growth_times_gaps',[],...   
    'shirnk_speeds_gaps',[],...   
    'shrink_times_gaps',[],...   
    'shirnk_speeds_gaps_minLT4',[],...   
    'shirnk_speeds_gaps_maxLT3',[]);
parser.growth_speeds_tracks = traj_meanDisp;
parser.growth_speeds_gaps = speedGrowth_GAP;
parser.growth_speeds_groups = speedGrowth;
parser.growth_speeds_gaps_minLT4 = speedGrowth_GAP_minLT4;
parser.growth_speeds_gaps_maxLT3 = speedGrowth_GAP_maxLT3;
parser.growth_percentGap = percentGap;
parser.growth_times_tracks = [traj([group.list]).len];% TRACKS IN GROUPS ONLY!!
parser.growth_times_groups = delta_T_gr;
parser.growth_times_gaps = delta_T_gr_GAP;
parser.shirnk_speeds_gaps = speedShrink;
parser.shrink_times_gaps = delta_T_sh;
parser.shirnk_speeds_gaps_minLT4 = speedShrink_minLT4;
parser.shirnk_speeds_gaps_maxLT3 = speedShrink_maxLT3;

gapsInSegment = (length([growth.list])-length(growth))/length(growth);
percentTimeShrink = sum(delta_T_sh)/(sum(delta_T_gr_GAP)+sum([traj([group.list]).len]));% TRACKS IN GROUPS ONLY!!
probShrink = length(find([group.direction]<0))/length([group.direction]);

nbTracksLT4 = length(traj);
percentTracksGrouped = length(group_list)/nbTracksLT4;
nbGroups = length(group);
nbFeaturesTrackedLT4 = sum([traj.len]);

% save([dirName(1:end-8),filesep,'groups',filesep,'parser37deg'],'parser') 
% save(([dirName(1:end-8),filesep,'groups',filesep,'parameters37deg','.mat']),'pixelSize',...
%     'samplingRate','minLT','percentTracksGrouped','nbTracksLT4','nbGroups','nbFeaturesTrackedLT4',...
%     'gapsInSegment', 'probShrink','percentTimeShrink');

