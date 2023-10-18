function regionsMTclusters



tr_sp_lam_ctr = []; % track speed
ga_sp_lam_ctr = []; % gap speed
sh_sp_lam_ctr = []; % shrink speed
pr_sh_lam_ctr = []; % prob of shrinkage
ti_sh_lam_ctr = []; % percentage time in shrinkage
dr_sh_lam_ctr = []; % delta t shrinkage

tr_sp_bod_ctr = []; % track speed
ga_sp_bod_ctr = []; % gap speed
sh_sp_bod_ctr = []; %
pr_sh_bod_ctr = [];
ti_sh_bod_ctr = [];
dr_sh_bod_ctr = [];

tr_sp_lam_gsk = []; % track speed
ga_sp_lam_gsk = []; % gap speed
sh_sp_lam_gsk = []; %
pr_sh_lam_gsk = [];
ti_sh_lam_gsk = [];
dr_sh_lam_gsk = [];

tr_sp_bod_gsk = []; % track speed
ga_sp_bod_gsk = []; % gap speed
sh_sp_bod_gsk = []; %
pr_sh_bod_gsk = [];
ti_sh_bod_gsk = [];
dr_sh_bod_gsk = [];

list(1).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\022608_#4\bod.tif'];
list(2).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\022608_#7\bod.tif'];
list(3).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\022608_#10\bod.tif'];
list(4).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\030708_#11\bod.tif'];
list(5).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\030708_#13\bod.tif'];
list(6).dir = ['X:\AlexData\Torsten\GSK_paper\37degs\030708_#14\bod.tif'];

for j = 1:6

    dirName = list(j).dir;
    %     I = imread([dirName(1:end-8),'\images\Subtract_01.tif']);

    % napravi maska na sredata mejdu nachalen i kraen koordinati na vseki GROUP
    load([dirName(1:end-8),'\point_files\config001_10p00_track_unidir.mat']);
    load([dirName(1:end-8),'\groups\group.mat']);
    traj=tracks(find([tracks.len]>=4));
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


    % naprvai dva 1-0 regiona - body i lamera - read images
    bod = imread([dirName(1:end-8),'\bod.tif']);
    lam = imread([dirName(1:end-8),'\lam.tif']);

    iL = 0; iB = 0;
    midGroup = zeros(size(lam,1),size(lam,2));

    % opredeli koi koord. v koi ot dvata raiona popadat - intersect
    for i = 1:length(group)
        if(~isempty([group(i).list]))
            %         midGroup(i,1) = round([(traj(group(i).list(end)).points(end,1) + traj(group(i).list(1)).points(1,1))/2]);
            %         midGroup(i,2) = round([(traj(group(i).list(end)).points(end,2) + traj(group(i).list(1)).points(1,2))/2]);
            y=round([(traj(group(i).list(end)).points(end,1) + traj(group(i).list(1)).points(1,1))/2]);
            x =round([(traj(group(i).list(end)).points(end,2) + traj(group(i).list(1)).points(1,2))/2]);
            midGroup(x,y) = 1;

            if lam(x,y) == 1
                iL = iL + 1;
                inLa(iL) = i;
            elseif bod(x,y) == 1
                iB = iB + 1;
                inBo(iB) = i;
            end
        end

    end
    % lamIn = lam .* midGroup;
    % bodIn = bod .* midGroup;
    % DEBUG

    % bootstrap statistiki
    [parser,percentTracksGrouped,gapsInSegment,probShrink,percentTimeShrink]= parseGroupsRegions(traj,group(inLa))

    tracks_speeds =       parser.growth_speeds_tracks;
    gaps_speeds =         parser.growth_speeds_gaps;
    %     groups_speeds =       parser.growth_speeds_groups;
    %     growth_times_tracks = parser.growth_times_tracks ;
    %     growth_times_groups = parser.growth_times_groups;
    %     growth_times_gaps =   parser.growth_times_gaps ;
    %     growth_percentGap =   parser.growth_percentGap ; % PERCENT GAPS
    shrink_speeds =       parser.shirnk_speeds_gaps;
    shrink_times =        parser.shrink_times_gaps;

    tr_sp_lam_ctr = [tr_sp_lam_ctr,tracks_speeds]; % track speed
    ga_sp_lam_ctr = [ga_sp_lam_ctr,gaps_speeds]; % gap speed
    sh_sp_lam_ctr = [sh_sp_lam_ctr,shrink_speeds]; %
    pr_sh_lam_ctr = [pr_sh_lam_ctr,probShrink];
    ti_sh_lam_ctr = [ti_sh_lam_ctr,percentTimeShrink];
    dr_sh_lam_ctr = [dr_sh_lam_ctr,shrink_times];
    %     MEAN_TRACK_SPEED = mean(tracks_speeds)
    %     STD_TRACK_SPEED = std(tracks_speeds)
    %     MEAN_GAP_SPEED = mean(gaps_speeds)
    %     STD_GAP_SPEED = std(gaps_speeds)
    %     DELTA_T_TRACK = mean(growth_times_tracks)/2.5
    %     DELTA_T_GAP = mean(growth_times_gaps)/2.5
    %     DELTA_T_SEGMENT = mean(growth_times_groups)/2.5
    %     GAP_To_GROWTH = mean(growth_percentGap)
    %     MEAN_GROUP_SPEED = mean(groups_speeds)
    %     STD_GROUP_SPEED = std(groups_speeds)
    %     MEAN_SHRINK_SPEED = mean(shrink_speeds)
    %     STD_SHRINK_SPEED = std(shrink_speeds)
    %     DELTA_T_SHRINK = mean(shrink_times)/2.5
    clear tracks_speeds
    clear gaps_speeds
    clear shrink_speeds
    clear shrink_times
    % bootstrap statistiki
    [parser,percentTracksGrouped,gapsInSegment,probShrink,percentTimeShrink]= parseGroupsRegions(traj,group(inBo))

    tracks_speeds =       parser.growth_speeds_tracks;
    gaps_speeds =         parser.growth_speeds_gaps;
    %     groups_speeds =       parser.growth_speeds_groups;
    growth_times_tracks = parser.growth_times_tracks ;
    growth_times_groups = parser.growth_times_groups;
    %     growth_times_gaps =   parser.growth_times_gaps ;
    %     growth_percentGap =   parser.growth_percentGap ; % PERCENT GAPS
    shrink_speeds =       parser.shirnk_speeds_gaps;
    shrink_times =        parser.shrink_times_gaps;

    tr_sp_bod_ctr = [tr_sp_bod_ctr,tracks_speeds]; % track speed
    ga_sp_bod_ctr = [ga_sp_bod_ctr, gaps_speeds]; % gap speed
    sh_sp_bod_ctr = [sh_sp_bod_ctr, shrink_speeds]; %
    pr_sh_bod_ctr = [pr_sh_bod_ctr, probShrink];
    ti_sh_bod_ctr = [ti_sh_bod_ctr, percentTimeShrink];
    dr_sh_bod_ctr = [dr_sh_bod_ctr, shrink_times];
    %     MEAN_TRACK_SPEED = mean(tracks_speeds)
    %     STD_TRACK_SPEED = std(tracks_speeds)
    %     MEAN_GAP_SPEED = mean(gaps_speeds)
    %     STD_GAP_SPEED = std(gaps_speeds)
    %     DELTA_T_TRACK = mean(growth_times_tracks)/2.5
    %     DELTA_T_GAP = mean(growth_times_gaps)/2.5
    %     DELTA_T_SEGMENT = mean(growth_times_groups)/2.5
    %     GAP_To_GROWTH = mean(growth_percentGap)
    %     MEAN_GROUP_SPEED = mean(groups_speeds)
    %     STD_GROUP_SPEED = std(groups_speeds)
    %     MEAN_SHRINK_SPEED = mean(shrink_speeds)
    %     STD_SHRINK_SPEED = std(shrink_speeds)
    %     DELTA_T_SHRINK = mean(shrink_times)/2.5
    clear inBo
    clear inLa
    clear tracks_speeds
    clear gaps_speeds
    clear shrink_speeds
    clear shrink_times
end

list(1).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022208_#1\bod.tif'];
list(2).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022208_#5\bod.tif'];
list(3).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#1\bod.tif'];
list(4).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#2\bod.tif'];
list(5).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#8\bod.tif'];
list(6).dir = ['X:\AlexData\Torsten\GSK_paper\gsk_100x\022608_#9\bod.tif'];

for j = 1:6

    dirName = list(j).dir;
    %     I = imread([dirName(1:end-8),'\images\Subtract_01.tif']);

    % napravi maska na sredata mejdu nachalen i kraen koordinati na vseki GROUP
    load([dirName(1:end-8),'\point_files\config001_10p00_track_unidir.mat']);
    load([dirName(1:end-8),'\groups\group.mat']);
    traj=tracks(find([tracks.len]>=4));
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


    % naprvai dva 1-0 regiona - body i lamera - read images
    bod = imread([dirName(1:end-8),'\bod.tif']);
    lam = imread([dirName(1:end-8),'\lam.tif']);

    iL = 0; iB = 0;
    midGroup = zeros(size(lam,1),size(lam,2));

    % opredeli koi koord. v koi ot dvata raiona popadat - intersect
    for i = 1:length(group)
        if(~isempty([group(i).list]))
            %         midGroup(i,1) = round([(traj(group(i).list(end)).points(end,1) + traj(group(i).list(1)).points(1,1))/2]);
            %         midGroup(i,2) = round([(traj(group(i).list(end)).points(end,2) + traj(group(i).list(1)).points(1,2))/2]);
            y=round([(traj(group(i).list(end)).points(end,1) + traj(group(i).list(1)).points(1,1))/2]);
            x =round([(traj(group(i).list(end)).points(end,2) + traj(group(i).list(1)).points(1,2))/2]);
            midGroup(x,y) = 1;

            if lam(x,y) == 1
                iL = iL + 1;
                inLa(iL) = i;
            elseif bod(x,y) == 1
                iB = iB + 1;
                inBo(iB) = i;
            end
        end

    end
    % lamIn = lam .* midGroup;
    % bodIn = bod .* midGroup;
    % DEBUG

    % bootstrap statistiki
    [parser,percentTracksGrouped,gapsInSegment,probShrink,percentTimeShrink]= parseGroupsRegions(traj,group(inLa))

    tracks_speeds =       parser.growth_speeds_tracks;
    gaps_speeds =         parser.growth_speeds_gaps;
    %     groups_speeds =       parser.growth_speeds_groups;
    %     growth_times_tracks = parser.growth_times_tracks ;
    %     growth_times_groups = parser.growth_times_groups;
    %     growth_times_gaps =   parser.growth_times_gaps ;
    %     growth_percentGap =   parser.growth_percentGap ; % PERCENT GAPS
    shrink_speeds =       parser.shirnk_speeds_gaps;
    shrink_times =        parser.shrink_times_gaps;

    tr_sp_lam_gsk = [tr_sp_lam_gsk,tracks_speeds]; % track speed
    ga_sp_lam_gsk = [ga_sp_lam_gsk,gaps_speeds]; % gap speed
    sh_sp_lam_gsk = [sh_sp_lam_gsk,shrink_speeds]; %
    pr_sh_lam_gsk = [pr_sh_lam_gsk,probShrink];
    ti_sh_lam_gsk = [ti_sh_lam_gsk,percentTimeShrink];
    dr_sh_lam_gsk = [dr_sh_lam_gsk,shrink_times];
    %     MEAN_TRACK_SPEED = mean(tracks_speeds)
    %     STD_TRACK_SPEED = std(tracks_speeds)
    %     MEAN_GAP_SPEED = mean(gaps_speeds)
    %     STD_GAP_SPEED = std(gaps_speeds)
    %     DELTA_T_TRACK = mean(growth_times_tracks)/2.5
    %     DELTA_T_GAP = mean(growth_times_gaps)/2.5
    %     DELTA_T_SEGMENT = mean(growth_times_groups)/2.5
    %     GAP_To_GROWTH = mean(growth_percentGap)
    %     MEAN_GROUP_SPEED = mean(groups_speeds)
    %     STD_GROUP_SPEED = std(groups_speeds)
    %     MEAN_SHRINK_SPEED = mean(shrink_speeds)
    %     STD_SHRINK_SPEED = std(shrink_speeds)
    %     DELTA_T_SHRINK = mean(shrink_times)/2.5
    clear tracks_speeds
    clear gaps_speeds
    clear shrink_speeds
    clear shrink_times
    % bootstrap statistiki
    [parser,percentTracksGrouped,gapsInSegment,probShrink,percentTimeShrink]= parseGroupsRegions(traj,group(inBo))

    tracks_speeds =       parser.growth_speeds_tracks;
    gaps_speeds =         parser.growth_speeds_gaps;
    %     groups_speeds =       parser.growth_speeds_groups;
    growth_times_tracks = parser.growth_times_tracks ;
    growth_times_groups = parser.growth_times_groups;
    %     growth_times_gaps =   parser.growth_times_gaps ;
    %     growth_percentGap =   parser.growth_percentGap ; % PERCENT GAPS
    shrink_speeds =       parser.shirnk_speeds_gaps;
    shrink_times =        parser.shrink_times_gaps;

    tr_sp_bod_gsk = [tr_sp_bod_gsk,tracks_speeds]; % track speed
    ga_sp_bod_gsk = [ga_sp_bod_gsk, gaps_speeds]; % gap speed
    sh_sp_bod_gsk = [sh_sp_bod_gsk, shrink_speeds]; %
    pr_sh_bod_gsk = [pr_sh_bod_gsk, probShrink];
    ti_sh_bod_gsk = [ti_sh_bod_gsk, percentTimeShrink];
    dr_sh_bod_gsk = [dr_sh_bod_gsk, shrink_times];
    %     MEAN_TRACK_SPEED = mean(tracks_speeds)
    %     STD_TRACK_SPEED = std(tracks_speeds)
    %     MEAN_GAP_SPEED = mean(gaps_speeds)
    %     STD_GAP_SPEED = std(gaps_speeds)
    %     DELTA_T_TRACK = mean(growth_times_tracks)/2.5
    %     DELTA_T_GAP = mean(growth_times_gaps)/2.5
    %     DELTA_T_SEGMENT = mean(growth_times_groups)/2.5
    %     GAP_To_GROWTH = mean(growth_percentGap)
    %     MEAN_GROUP_SPEED = mean(groups_speeds)
    %     STD_GROUP_SPEED = std(groups_speeds)
    %     MEAN_SHRINK_SPEED = mean(shrink_speeds)
    %     STD_SHRINK_SPEED = std(shrink_speeds)
    %     DELTA_T_SHRINK = mean(shrink_times)/2.5
    clear inBo
    clear inLa
    clear tracks_speeds
    clear gaps_speeds
    clear shrink_speeds
    clear shrink_times
end

% boxplots
tor = xlsread('X:\AlexData\Torsten\trichostatinA\jcb_gsk3_growthrates.xls'); %\tracking_data1.xls');
gr100b = tor(:,2)';%tr_sp_lam_ctr;
gr60b = tor(:,1)';%tr_sp_bod_ctr;
gr50b = tor(:,4)';%tr_sp_lam_gsk;
gr30b = tor(:,3)';%tr_sp_bod_gsk;

ga100 = ga_sp_lam_ctr;
ga60 = ga_sp_bod_ctr;
ga50 = ga_sp_lam_gsk;
ga30 = ga_sp_bod_gsk;
% 
s100 = sh_sp_lam_ctr;
s60 = sh_sp_bod_ctr;
s50 = sh_sp_lam_gsk;
s30 = sh_sp_bod_gsk;
%---------------------------group------------------------------------------
% grsi = max([size(gr100,2),size(gr60,2),size(gr50,2),size(gr30,2)]);

% grN00(1:grsi - size(gr100,2))=nan;
% gr100b = [gr100,grN00];
% grN60(1:grsi - size(gr60,2))=nan;
% gr60b = [gr60,grN60];
% grN50(1:grsi - size(gr50,2))=nan;
% gr50b = [gr50,grN50];
% grN30(1:grsi - size(gr30,2))=nan;
% gr30b = [gr30,grN30];

figure, boxplot([gr100b',gr60b',gr50b',gr30b'],'notch','on','whisker',1.5,  ...
    'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
     'positions' , [ 1, 3, 5, 7])
ylim([-2 70])
ylabel('Microtubule Growth Speeds');
%----------------------gap-------------------------------------------------
% gasi = max([size(ga100,2),size(ga60,2),size(ga50,2),size(ga30,2)]);
% 
% gaN00(1:gasi - size(ga100,2))=nan;
% ga100b = [ga100,gaN00];
% gaN60(1:gasi - size(ga60,2))=nan;
% ga60b = [ga60,gaN60];
% gaN50(1:gasi - size(ga50,2))=nan;
% ga50b = [ga50,gaN50];
% gaN30(1:gasi - size(ga30,2))=nan;
% ga30b = [ga30,gaN30];
% 
% figure, boxplot([ga100b',ga60b',ga50b',ga30b'],'notch','on','whisker',1.5,  ...
%    'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
%      'positions' , [ 1, 3, 5, 7])
% ylabel('Microtubule Gap Speeds');
%------------------------------shrink--------------------------------------------
[cutoffInd, cutoffV] = cutFirstHistMode(ga100,1);
CUTOFF_SPEED = cutoffV

s100 = s100(find(s100>cutoffV));
s60 = s60(find(s60>cutoffV));
s50 = s50(find(s50>cutoffV));
s30 = s30(find(s30>cutoffV));

% - test
[h,p_long] = ttest2(s100,s50)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(s100),50);
    v1=s100(i1);

    i2 = randsample(length(s50),50);
    v2=s50(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)
% - test
[h,p_long] = ttest2(gr100b,gr50b)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(gr100b),400);
    v1=gr100b(i1);

    i2 = randsample(length(gr50b),400);
    v2=gr50b(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)

ssi = max([size(s100,2),size(s60,2),size(s50,2),size(s30,2)]);


sN00(1:ssi - size(s100,2))=nan;
s100b = [s100,sN00];
sN60(1:ssi - size(s60,2))=nan;
s60b = [s60,sN60];
sN50(1:ssi - size(s50,2))=nan;
s50b = [s50,sN50];
sN30(1:ssi - size(s30,2))=nan;
s30b = [s30,sN30];

figure, boxplot([s100b',s60b',s50b',s30b'],'notch','on','whisker',1.5,  ...
   'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
     'positions' , [ 1, 3, 5, 7])
 ylim([-2 70])
ylabel('Microtubule Shrinkage Speeds');

%---------shrink-params---
% % boxplots
% r100 = pr_sh_lam_ctr*100;
% r60 = pr_sh_bod_ctr*100;
% r50 = pr_sh_lam_gsk*100;
% r30 = pr_sh_bod_gsk*100;
% 
% a100 = ti_sh_lam_ctr*100;
% a60 = ti_sh_bod_ctr*100;
% a50 = ti_sh_lam_gsk*100;
% a30 = ti_sh_bod_gsk*100;
% 
% ss100 = dr_sh_lam_ctr/2.5;
% ss60 = dr_sh_bod_ctr/2.5;
% ss50 = dr_sh_lam_gsk/2.5;
% ss30 = dr_sh_bod_gsk/2.5;
% 
% figure, boxplot([r100',r60',r50',r30'],'notch','on','whisker',1.5,  ...
%     'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
%      'positions' , [ 1, 3, 5, 7])
% ylabel('Probability of Shrinking (per region) [%]');
% %----------------------gap-------------------------------------------------
% 
% figure, boxplot([a100',a60',a50',a30'],'notch','on','whisker',1.5,  ...
%    'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
%      'positions' , [ 1, 3, 5, 7])
% ylabel('Time in Shinking (per region) [%]');
%------------------------------shrink--------------------------------------------
% ssi = max([size(ss100,2),size(ss60,2),size(ss50,2),size(ss30,2)]);
% 
% ssN00(1:ssi - size(ss100,2))=nan;
% ss100b = [ss100,ssN00];
% ssN60(1:ssi - size(ss60,2))=nan;
% ss60b = [ss60,ssN60];
% ssN50(1:ssi - size(ss50,2))=nan;
% ss50b = [ss50,ssN50];
% ssN30(1:ssi - size(ss30,2))=nan;
% ss30b = [ss30,ssN30];
% 
% figure, boxplot([ss100b',ss60b',ss50b',ss30b'],'notch','on','whisker',1.5,  ...
%    'widths', 0.8, 'labels', {'CL','CB', 'GL', 'GB'},...
%      'positions' , [ 1, 3, 5, 7])
% ylabel('Delta T Shrinking [sec]');

ssi
 
 
