function scatterPlotEB1 

% NOCO -> Eccentricity vs Speed
% -----------------------------------------------------------------------
% 100nM_Noc#02, 10nM_Noc#05, 1nM_Noc#00, no_Noc#05
dirName = 'X:\AlexData\Torsten\020608_nocodazole_titration_EB1\10nM_Noc#05\';

% - INTENSITY VS SPEED
%-----------------------------------------------------------------------
load([dirName,'point_files',filesep,'config001_4p00_track_bidir.mat']);


x1 = []; x2 = []; y1 = []; y2 = [];
traj1 = tracks(find([tracks.len]>=4)); % only long ones


n = 0;
for j = 1:75 % number of images
    traj = []; leIndx = [];x = []; y = [];
    traj = traj1(find([traj1.startID]==j)); % those that start in frame 1
    leIndx = length(traj);
    
        strg=sprintf('%%.%dd',2);
    indxStr=sprintf(strg,j);
    load([dirName,'cands',filesep,'feats',indxStr,'.mat']);
    y = feats.pos(:,1);
    x = feats.pos(:,2);
    
    for i = 1:leIndx
        aux1 = []; aux2 = [];
        traj(i).endID = traj(i).startID + traj(i).len - 1;
        dY = traj(i).points(end,1) - traj(i).points(1,1);
        dX = traj(i).points(end,2) - traj(i).points(1,2);
        traj(i).vec = [dX; dY];
        traj(i).vel = sqrt(dY^2+dX^2)/traj(i).len*60*0.0642/0.39;
        %----------------------------FIND CORRESPONDING ECC-------------------
        aux1 = find(y == traj(i).points(1,1));
        aux2 = find(x == traj(i).points(1,2));
        if ~isempty(aux1) && ~isempty(aux2)
            if (aux1(1) == aux2(1))
                if (feats.ecc(aux1)>0)
                    n = n+1;
                    ecc(n) = feats.ecc(aux1(1));
                    vel(n) = traj(i).vel;
                end
            end
        end
        %-----------------------------------------------
    end

end
 
figure, plot(vel,ecc,'b.')
xlim([0 25]) 
n