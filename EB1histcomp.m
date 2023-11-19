function [compMatrices,compMatricesC1,compMatricesC2,compMatricesC3] = EB1histcomp


load('X:\AlexData11\786O\786O_parental\786Opar_NaCl01\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(1).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl02\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(2).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl03\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(3).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl04\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(4).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl05\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(5).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl08\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(6).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl09\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(7).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl11\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(8).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\786Opar_NaCl12\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(9).avgV = avgV;

load('X:\AlexData11\786O\786O_parental\060907_786Opar_12\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC2(10).avgV = avgV;

dataC2(11).avgV = cat(2,dataC2.avgV); % ALL TOGETHER

compMatricesC2(1) = discriminationMatrix(dataC2); % under diag - mean comparison; above diag - Distr comp (without mean)

compMatricesC2(2) = discriminationMatrix(dataC2,struct('avgV',[2,12])); % 2 - comp the median (under), 12 - KS (without median)(above)

compMatricesC2(3) = discriminationMatrix(dataC2,struct('avgV',[10,10])); % 10 - KS (no correction) (both above & under)

compMatricesC2.avgV
%--------------------------------------------------------------------------

load('X:\AlexData11\786O\786OVHL\786OVHL30_NaCl09\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC3(1).avgV = avgV;

load('X:\AlexData11\786O\786OVHL\786OVHL30_NaCl10\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC3(2).avgV = avgV;

load('X:\AlexData11\786O\786OVHL\786OVHL30_NaCl11\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC3(3).avgV = avgV;

load('X:\AlexData11\786O\786OVHL\786OVHL30_NaCl12\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC3(4).avgV = avgV;

load('X:\AlexData11\786O\786OVHL\786OVHL30_NaCl13\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat');

dataC3(5).avgV = avgV;

dataC3(6).avgV = cat(2,dataC3.avgV);

compMatricesC3(1) = discriminationMatrix(dataC3); % under diag - mean comparison; above diag - Distr comp (without mean)

compMatricesC3(2) = discriminationMatrix(dataC3,struct('avgV',[2,12])); % 2 - comp the median (under), 12 - KS (without median)(above)

compMatricesC3(3) = discriminationMatrix(dataC3,struct('avgV',[10,10])); % 10 - KS (no correction) (both above & under)

compMatricesC3.avgV
%--------------------------------------------------------------------------

% data(1).avgV = dataC1(6).avgV;

data(1).avgV = dataC2(6).avgV;

data(2).avgV = dataC3(6).avgV;

% compMatrices(1) = discriminationMatrix(data); % under diag - mean comparison; above diag - Distr comp (without mean)

compMatrices(1) = discriminationMatrix(data,struct('avgV',[2,12])); % 2 - comp the median (under), 12 - KS (without median)(above)

compMatrices(2) = discriminationMatrix(data,struct('avgV',[10,10])); % 10 - KS (no correction) (both above & under)

compMatrices.avgV

