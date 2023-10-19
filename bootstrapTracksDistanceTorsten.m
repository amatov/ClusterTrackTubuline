function bootstrapTracksDistanceTorsten

load(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\point_files\config001_4p00_track_bidir.mat']);
% load(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\point_files\config001_4p00_track_bidir.mat']);

I = imread(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\images\ctrl_60x#6_t01.tif']);
img2 = imread(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\cell_mask\mask_ctrl_60x#6_t01.tif']);% CELL BODY 1-0 MASK
% I = imread(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\images\0nm_10_t01.tif']);
% img2 =imread(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\cell_mask\mask_0nm_10_t01.tif']);% CELL BODY 1-0 MASK
distance_image = bwdist(~img2);

CO = 5;
VELO = 19;
CUT = 3.65;%5.6%6.4;%10.9;%3.65;%C1


x1 = []; x2 = []; y1 = []; y2 = [];
traj = tracks(find([tracks.len]>=CO));
leIndx = length(traj);
m = 0; n = 0;
% calculate trajectory information
for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
    dY = traj(i).points(end,1) - traj(i).points(1,1);
    dX = traj(i).points(end,2) - traj(i).points(1,2);
    traj(i).vec = [dX; dY];
            %----------------------------DISTANCE-TO-EDGE-------------------
        traj(i).dist = 0.107 * distance_image(round(traj(i).points(end,2)),round(traj(i).points(end,1)));
end

trajEdge = traj(find([traj.dist]<=CUT));
trajBody = traj(find([traj.dist]>CUT));

% grouping of two reagions' tracks
groupEdge = groupTorstenEdge(trajEdge);
groupBody = groupTorstenEdge(trajBody);

% parsing of two regions' groups
groupEdge = parseGroupsTorstenEdge(groupEdge,trajEdge,'Edge');
groupBody = parseGroupsTorstenEdge(groupBody,trajBody,'Body');

% bootstrap of two regions' groups- RE-LOAD-FROM-HERE
load(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\groups\parserEdge']);
load(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\groups\parametersEdge']);
% load(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\groups\parserEdge']);
% load(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\groups\parametersEdge']);

percGrpdEdge = percentTracksGrouped
gapsInSegmEdge = gapsInSegment
probShrnkEdge = probShrink
prcTimeShrnkEdge = percentTimeShrink

tracks_speedsEdge =       parser.growth_speeds_tracks;
gaps_speedsEdge =         parser.growth_speeds_gaps;
groups_speedsEdge =       parser.growth_speeds_groups;  
growth_times_tracksEdge = parser.growth_times_tracks;
growth_times_groupsEdge = parser.growth_times_groups;  
growth_times_gapsEdge =   parser.growth_times_gaps ;
growth_percentGapEdge =   parser.growth_percentGap ; % PERCENT GAPS
shrink_speedsEdge =       parser.shirnk_speeds_gaps;  
shrink_timesEdge =        parser.shrink_times_gaps;  

MEAN_TRACK_SPEED = mean(tracks_speedsEdge)
STD_TRACK_SPEED = std(tracks_speedsEdge)
MEAN_GAP_SPEED = mean(gaps_speedsEdge)
STD_GAP_SPEED = std(gaps_speedsEdge)
DELTA_T_TRACK = mean(growth_times_tracksEdge)/(1/samplingRate)
DELTA_T_GAP = mean(growth_times_gapsEdge)/(1/samplingRate)
DELTA_T_SEGMENT = mean(growth_times_groupsEdge)/(1/samplingRate)
GAP_To_GROWTH = mean(growth_percentGapEdge)
MEAN_GROUP_SPEED = mean(groups_speedsEdge)
STD_GROUP_SPEED = std(groups_speedsEdge)
MEAN_SHRINK_SPEED = mean(shrink_speedsEdge)
STD_SHRINK_SPEED = std(shrink_speedsEdge)
DELTA_T_SHRINK = mean(shrink_timesEdge)/(1/samplingRate)

load(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\groups\parserBody']);
load(['X:\AlexData\Torsten\trichostatinA\ctrl\cell1\groups\parametersBody']);
% load(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\groups\parserBody']);
% load(['X:\AlexData\Torsten\020608_nocodazole_titration_EB1\no_Noc#07\groups\parametersBody']);

percGrpdBody = percentTracksGrouped
gapsInSegmBody = gapsInSegment
probShrnkBody = probShrink
prcTimeShrnkBody = percentTimeShrink

tracks_speedsBody =       parser.growth_speeds_tracks;
gaps_speedsBody =         parser.growth_speeds_gaps;
groups_speedsBody =       parser.growth_speeds_groups;  
growth_times_tracksBody = parser.growth_times_tracks;
growth_times_groupsBody = parser.growth_times_groups;  
growth_times_gapsBody =   parser.growth_times_gaps ;
growth_percentGapBody =   parser.growth_percentGap ; % PERCENT GAPS
shrink_speedsBody =       parser.shirnk_speeds_gaps;  
shrink_timesBody =        parser.shrink_times_gaps;  

MEAN_TRACK_SPEED = mean(tracks_speedsBody)
STD_TRACK_SPEED = std(tracks_speedsBody)
MEAN_GAP_SPEED = mean(gaps_speedsBody)
STD_GAP_SPEED = std(gaps_speedsBody)
DELTA_T_TRACK = mean(growth_times_tracksBody)/(1/samplingRate)
DELTA_T_GAP = mean(growth_times_gapsBody)/(1/samplingRate)
DELTA_T_SEGMENT = mean(growth_times_groupsBody)/(1/samplingRate)
GAP_To_GROWTH = mean(growth_percentGapBody)
MEAN_GROUP_SPEED = mean(groups_speedsBody)
STD_GROUP_SPEED = std(groups_speedsBody)
MEAN_SHRINK_SPEED = mean(shrink_speedsBody)
STD_SHRINK_SPEED = std(shrink_speedsBody)
DELTA_T_SHRINK = mean(shrink_timesBody)/(1/samplingRate)

gr100 = tracks_speedsEdge
gr60 = tracks_speedsBody
ga100 = gaps_speedsEdge
ga60 = gaps_speedsBody
s100 = shrink_speedsEdge
s60 = shrink_speedsBody
% boxplot of growth gaps shrink of two regions' groups
grsi = max([size(gr100,2),size(gr60,2)]);

grN00(1:grsi - size(gr100,2))=nan;
gr100b = [gr100,grN00];
grN60(1:grsi - size(gr60,2))=nan;
gr60b = [gr60,grN60];

figure, boxplot([gr100b',gr60b'],'notch','on','whisker',1.5,  ...
    'widths', 0.8, 'labels', {'Lamella','Body'},...
     'positions' , [ 1, 3])
  ylim([-2 60])
ylabel('Microtubule Growth Speeds');
%----------------------gap-------------------------------------------------
% gasi = max([size(ga100,2),size(ga60,2)]);
% 
% gaN00(1:gasi - size(ga100,2))=nan;
% ga100b = [ga100,gaN00];
% gaN60(1:gasi - size(ga60,2))=nan;
% ga60b = [ga60,gaN60];
% 
% figure, boxplot([ga100b',ga60b'],'notch','on','whisker',1.5,  ...
%    'widths', 0.8, 'labels', {'Lamella','Body'},...
%      'positions' , [ 1, 3])
% ylabel('Microtubule Gap Speeds');
%------------------------------shrink--------------------------------------------
[cutoffInd, cutoffV] = cutFirstHistMode(ga100,0);
CUTOFF_SPEED = cutoffV

s100 = s100(find(s100>cutoffV));
s60 = s60(find(s60>cutoffV));

% - test
[h,p_long] = ttest2(s100,s60)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(s100),50);
    v1=s60(i1);

    i2 = randsample(length(s60),50);
    v2=s60(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)
% - test
[h,p_long] = ttest2(gr100,gr60)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(gr100),400);
    v1=gr100(i1);

    i2 = randsample(length(gr60),400);
    v2=gr60(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)
%--------

ssi = max([size(s100,2),size(s60,2)]);

sN00(1:ssi - size(s100,2))=nan;
s100b = [s100,sN00];
sN60(1:ssi - size(s60,2))=nan;
s60b = [s60,sN60];

figure, boxplot([s100b',s60b'],'notch','on','whisker',1.5,  ...
   'widths', 0.8, 'labels', {'Lamella','Body'},...
     'positions' , [ 1, 3])
 ylim([-2 60])
ylabel('Microtubule Shrinkage Speeds');
a
%---------------------------------------

