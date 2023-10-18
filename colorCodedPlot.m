function [binN, binCtr, dClass, cIndex, figH, d, davg, dstd, subCmap, totalTrackNum, totalPointNumber] = colorCodedPlot(traj)

cmapName = 'jet';


% identify the index of entries within the lifetime window
% if length(ltWin) > 1
%     minLifetime = ltWin(1);
%     maxLifetime = ltWin(2);
% else
%     minLifetime = ltWin;
%     maxLifetime = inf;
% end;
% if minLifetime < 2
%     minLifetime = 2;
% end;

% lt = [traj.len];
% indx = find( (lt >= minLifetime) & (lt <= maxLifetime));

indx = [];

totalPointNumber = 0;

for i = 1 : length(traj)
%     if (traj(i).len >= minLifetime) & (traj(i).len <= maxLifetime) & (traj(i).meanDisp <= hardFluxRateThreshold)
        indx = [indx, i];
        totalPointNumber = totalPointNumber + traj(i).len;
%     end
end

totalTrackNum = length(indx);

% extract the mean displacements
d = [traj(indx).meanDisp];

davg = mean(d);
dstd = std(d);

% set the bin centers unless specified externally
minD = min(d);
maxD = max(d);

% if length(binCtrIn)==1
    binCtr = minD : ((maxD-minD)/(7)) : maxD;
% else
%     binCtr = binCtrIn;
% end

% calculate histogram
binN = hist(d, binCtr);

% begin drawing the histogram
f1 = figure;

% before we begin with the drawing construct a sub-sampled colormap
cmap = colormap(cmapName);
nColors = size(cmap, 1);
if nColors < length(binN)
    error('too many bins for the selected colormap');
end
cIndex = round(1 : (nColors-1)/(length(binN)-1) : nColors);
subCmap = cmap(cIndex,:);

% for the moment, since I do not know how to retrieve the face color of all
% bars at once we draw the bars step by step. 
hold on;
barWidth = binCtr(2)-binCtr(1);
for i = 1 : length(binN)
    xPoly = [binCtr(i)-0.5*barWidth, binCtr(i) + 0.5 * barWidth, binCtr(i) + 0.5 * barWidth, binCtr(i) - 0.5*barWidth];
    yPoly = [0, 0, binN(i), binN(i)];
    fill(xPoly, yPoly, subCmap(i,:));
end;

% classify the trajectories
for i = 2 : (length(binCtr)-1)
    dClass(i)={indx(find((d > (binCtr(i)-0.5*barWidth)) & (d <= (binCtr(i) + 0.5*barWidth))))};
end
% first and last class
dClass(1) = {indx(find(d <= (binCtr(1) + 0.5*barWidth)))};
dClass(length(binCtr))={indx(find(d > (binCtr(end) - 0.5*barWidth)))};

% the following line is useful to test the address mapping
% gg= [traj(dClass{3}).meanDisp];

f2 = figure;
% imshow(img, []);

% over all classes ...
for i = 1:length(dClass)
    auxIndx = dClass{i};
    % over all trajectories in the class ...
    hold on;
    for j = 1:length(auxIndx)
        lh = plot(traj(auxIndx(j)).points(:,1),traj(auxIndx(j)).points(:,2),'-', 'LineWidth', 2);
        set(lh,'Color', subCmap(i,:));
    end
end
figH = [f1, f2];
    
    
    
    
