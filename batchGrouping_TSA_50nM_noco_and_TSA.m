function batchGrouping_TSA_noco_and_TSA


% fileName = ['config001_4p00_track_bidir.mat'];
% 
% dirName = ['X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell1\point_files\'];
% groupingLAP(fileName,dirName);
% dirName = ['X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell2\point_files\'];
% groupingLAP(fileName,dirName);
% dirName = ['X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell3\point_files'];
% groupingLAP(fileName,dirName);
%  
% parseGroups('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell1\images\');
% parseGroups('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell2\images\');
% parseGroups('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell3\images\');

load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell1\groups\parameters.mat');
p(1) = percentTracksGrouped;
g(1) = gapsInSegment;
pr(1) = probShrink;
pt(1) = percentTimeShrink;
load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell1\groups\parser.mat');
hists(1)  = parser ;

load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell2\groups\parameters.mat');
p(2) = percentTracksGrouped;
g(2) = gapsInSegment;
pr(2) = probShrink;
pt(2) = percentTimeShrink;
load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell2\groups\parser.mat');
hists(2)  = parser ;

load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell3\groups\parameters.mat');
p(3) = percentTracksGrouped;
g(3) = gapsInSegment;
pr(3) = probShrink;
pt(3) = percentTimeShrink;
load('X:\AlexData\Torsten\trichostatinA\noco_and_TSA\cell3\groups\parser.mat');
hists(3)  = parser ;

tracks_speeds =       cat(2,hists.growth_speeds_tracks);  
gaps_speeds =         cat(2,hists.growth_speeds_gaps);  
groups_speeds =       cat(2,hists.growth_speeds_groups);  
growth_times_tracks = cat(2,hists.growth_times_tracks) ;
growth_times_groups = cat(2,hists.growth_times_groups);  
growth_times_gaps =   cat(2,hists.growth_times_gaps) ;
growth_percentGap =   cat(2,hists.growth_percentGap) ; % PERCENT GAPS
shrink_speeds =       cat(2,hists.shirnk_speeds_gaps);  
shrink_times =        cat(2,hists.shrink_times_gaps);  

MEAN_TRACK_SPEED = mean(tracks_speeds)
STD_TRACK_SPEED = std(tracks_speeds)
MEAN_GAP_SPEED = mean(gaps_speeds)
STD_GAP_SPEED = std(gaps_speeds)
DELTA_T_TRACK = mean(growth_times_tracks)/(1/samplingRate)
DELTA_T_GAP = mean(growth_times_gaps)/(1/samplingRate)
DELTA_T_SEGMENT = mean(growth_times_groups)/(1/samplingRate)
GAP_To_GROWTH = mean(growth_percentGap)
MEAN_GROUP_SPEED = mean(groups_speeds)
STD_GROUP_SPEED = std(groups_speeds)
MEAN_SHRINK_SPEED = mean(shrink_speeds)
STD_SHRINK_SPEED = std(shrink_speeds)
DELTA_T_SHRINK = mean(shrink_times)/(1/samplingRate)
percentTracksGrouped = mean(p)
gapsInSegment = mean(g)
probShrink = mean(pr)
percentTimeShrink = mean(pt)

data_set = shrink_speeds;
size_data_set=size(data_set,2);

minSiz = ceil(size_data_set/2); %min(siz); % smallest data set
maxSiz = size_data_set%max(siz); % all together

for i = 1:50
    indexList1 = ceil(rand(minSiz,1)*maxSiz);
    data1 = data_set(indexList1);
    mean1 = mean(data1);
       
    indexList2 = ceil(rand(minSiz,1)*maxSiz);
    data2 = data_set(indexList2);
    mean2 = mean(data2);
    
    %compare distributions: KS-test. Subtract means
    [dummy,pValue] = kstest2(data1-mean1, data2-mean2);

    p(i) = pValue;
end
p_value = mean(p)

p