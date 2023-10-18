function [track_speeds,mean_cells]=bootstrapingCLIP170shVHL;

name(1).dir = 'X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-vhl_CLIP170_01';
name(2).dir = 'X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-vhl_CLIP170_02';
name(3).dir = 'X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-vhl_CLIP170_03';
name(4).dir = 'X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-vhl_CLIP170_05';

for j = 1:4
    minLT = 4;dirName = name(j).dir;
    load([dirName,'\point_files\config001_5p00_track_bidir.mat']); %5
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
    traj = traj(find([traj.vel]>0)); % SOME DONT MOVE
    leT = length(traj);
    pixelSize = 0.11; % (microns)
    samplingRate = 0.5; % - Noco 1- if not -> 0.5; % (seconds)
    scaleFactor = pixelSize * 60 / samplingRate ;
    for i = 1 : leT
        d = diff(traj(i).points(:, 1:2));
        traj(i).meanDisp = sum(sqrt(sum(d.^2, 2)))/(traj(i).len-1)*scaleFactor ;
    end
    traj_meanDisp(j).growth_speed_tracks = [traj.meanDisp];
    mean_cells(j) = mean([traj.meanDisp]);
end
track_speeds = cat(2,traj_meanDisp.growth_speed_tracks); 