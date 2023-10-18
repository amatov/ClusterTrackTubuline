function [v_good,stats] = meanHistEB1


fileList = searchFiles('config001_5p00_track_bidir_uni_dir_analysisRecord.mat','','ask',1);

nMovies = size(fileList,1);

v = [];
for i = 1:nMovies
    load(fullfile(fileList{i,2},fileList{i,1}));
    
    t(i).v = avgV;
    
    v = [v,avgV];
    
    clear avgV
end

mean_v = mean(v);
for i = 1:nMovies
     [h_mean(i),p_mean(i)] = ttest2(v,t(i).v);
     
     mean_vi = mean(t(i).v);
     [h_dist(i),p_dist(i)] = kstest2(v/mean_v,t(i).v/mean_vi);  
end
     
good_mean = (p_mean > 0.00005);
good_dist = (p_dist > 0.00005);

% good = good_mean & good_dist;
good = good_dist;

v_good = cat(2,t(good).v);

stats = cat(1,good,good_mean,p_mean,good_dist,p_dist)';

figure, hist(v_good)

figure,plot(log10(stats(:,3)),log10(stats(:,5)),'.')
xlabel('p mean bad->good')
ylabel('p dist bad->good')

