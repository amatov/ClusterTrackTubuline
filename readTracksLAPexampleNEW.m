function readTracksLAPexampleNEW

TimeSpan = 20;
R = 1000000;
LifeTime = 4;
load(['X:\AlexData11\786O\786O_parental\786Opar_NaCl02_R3D\point_files\config001_5p00_track_bidir.mat']);

indx = find( [tracks.len] >= LifeTime);
traj = tracks(indx);
leIndx = length(indx);

for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
    E(i,:)=traj(i).points(end,1:2);
    B(i,:)=traj(i).points(1,1:2);
end

[listStartID,indxStartID] = sort([traj.startID]);

indxFrameJumpInListStartID = find(diff(listStartID));
if length(unique(listStartID)) ~= (length(indxFrameJumpInListStartID)+1)
    disp('there isnt a new track-beginning in every frame');
end

C = sparse(leIndx,leIndx);
for i = 1:leIndx
    if TimeSpan > length(indxFrameJumpInListStartID)-traj(i).endID
        T = length(indxFrameJumpInListStartID)-traj(i).endID;
    else 
        T = TimeSpan;
    end
    if traj(i).endID < length(indxFrameJumpInListStartID)
        a = indxStartID((indxFrameJumpInListStartID(traj(i).endID+1)):indxFrameJumpInListStartID(traj(i).endID+T));
        C(i,a)=1;
    end
end
length(find(C))

D=createSparseDistanceMatrix(E,B,R); % check speed for multiplying 2 sparse m's

CM = C.*D;
length(find(CM))

%link via LAP. nonlinkmarker=-1, augment the matrix and show
[links12, links21] = lap(CM,-1,0,1);
length(links12)
