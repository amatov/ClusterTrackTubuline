function bootstraping_test

load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_02\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(1).avgV = avgV;
siz(1)=size(dataC2(1).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_04\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(2).avgV = avgV;
siz(2)=size(dataC2(2).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_05\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(3).avgV = avgV;
siz(3)=size(dataC2(3).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_07\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(4).avgV = avgV;
siz(4)=size(dataC2(4).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_08\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(5).avgV = avgV;
siz(5)=size(dataC2(5).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_09\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(6).avgV = avgV;
siz(6)=size(dataC2(6).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_10\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(7).avgV = avgV;
siz(7)=size(dataC2(7).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_13\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(8).avgV = avgV;
siz(8)=size(dataC2(8).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_14\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(9).avgV = avgV;
siz(9)=size(dataC2(9).avgV,2);
load('X:\AlexData11\RCC4\RCC4-CMV00(empty)\060824_RCC4-CMVempty-LMP_15\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');
dataC2(10).avgV = avgV;
siz(10)=size(dataC2(10).avgV,2);

data_all = cat(2,dataC2.avgV,2); % ALL TOGETHER
siz(11)=size(data_all,2);

minSiz = min(siz); % smallest data set
maxSiz = max(siz); % all together

for i = 1:50
    indexList1 = ceil(rand(minSiz,1)*maxSiz);
    data1 = data_all(indexList1);
    mean1 = mean(data1);
    
    indexList2 = ceil(rand(minSiz,1)*maxSiz);
    data2 = data_all(indexList2);
    mean2 = mean(data2);
    
    % compare distributions: KS-test. Subtract means
    [dummy,pValue] = kstest2(data1-mean1, data2-mean2);

    p(i) = pValue;
end
p_value = mean(p)
p