function validationGrouping_EB1andMTs_20


fileName = ['config001_4p00_track_bidir.mat'];

dirName = ['X:\AlexData\Torsten\trackingValidation\EB1\point_files'];
groupingLAP(fileName,dirName);

parseGroups('X:\AlexData\Torsten\trackingValidation\EB1\images\');

load('X:\AlexData\Torsten\trackingValidation\EB1\groups\parser.mat');
hists= parser;
siz=size(hists.growth_speeds_tracks,2);

tracks_speeds =       cat(2,hists.growth_speeds_tracks);  
gaps_speeds =         cat(2,hists.growth_speeds_gaps);  
groups_speeds =       cat(2,hists.growth_speeds_groups);  
growth_times_groups = cat(2,hists.growth_times_groups);  
growth_times_gaps =   cat(2,hists.growth_times_gaps) ;
growth_percentGap =   cat(2,hists.growth_percentGap) ; % PERCENT GAPS
growth_gaps_minLT4 =  cat(2,hists.growth_speeds_gaps_minLT4 );
growth_gaps_maxLT3 =  cat(2,hists.growth_speeds_gaps_maxLT3 );

shrink_speeds =       cat(2,hists.shirnk_speeds_gaps);  
shrink_times =        cat(2,hists.shrink_times_gaps);  
shrink_minLT4 =       cat(2,hists.shirnk_speeds_gaps_minLT4) ;
shrink_maxLT3 =       cat(2,hists.shirnk_speeds_gaps_maxLT3) ;

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