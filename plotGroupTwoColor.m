function h = plotGroupTwoColor(traj,group)

grNb = length(group);
% I = imread(['X:\AlexData\Torsten\111607_EB1andMTs\111607_#20\EB1\images\EB_01.tif']);
% h = figure,imshow(I,[])
% hold on

h = figure;
for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
        plot(traj(k(1)).points(1,2),traj(k(1)).points(1,1),'ko')
        hold on
        for j = 1:le_gr
            plot(traj(k(j)).points(:,2),traj(k(j)).points(:,1),'k-')
            plot(traj(k(j)).points(end,2),traj(k(j)).points(end,1),'k*')
            plot([traj(k(j)).points(1,2),traj(k(j)).points(end,2)],[traj(k(j)).points(1,1),traj(k(j)).points(end,1)],'k--')
            if j < le_gr
                if group(i).direction(j) == 1%INDEX?
%                                         len = traj(k(j+1)).startID - traj(k(j)).startID - traj(k(j)).len + 1;
%                     dY = traj(k(j+1)).points(1,1) - traj(i).points(1,1);
%                     dX = traj(k(j+1)).points(1,2) - traj(i).points(1,2);
%                     vec = [dX; dY];
%                     vel = sqrt(dY^2+dX^2)/len;
%                     if vel > 9.3
%                     plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'r-')
%                     plot(traj(k(j+1)).points(1,2),traj(k(j+1)).points(1,1),'r*')
%                     else
%                     plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'b-')
%                     end
                    
                    plot([traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],[traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],'b-')
                    plot(traj(k(j+1)).points(1,2),traj(k(j+1)).points(1,1),'b*')
                elseif group(i).direction(j) == -1%INDEX?
%                     len = traj(k(j+1)).startID - traj(k(j)).startID - traj(k(j)).len + 1;
%                     dY = traj(k(j+1)).points(1,1) - traj(i).points(1,1);
%                     dX = traj(k(j+1)).points(1,2) - traj(i).points(1,2);
%                     vec = [dX; dY];
%                     vel = sqrt(dY^2+dX^2)/len;
%                     if vel > 9.3
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'r-')
                    plot(traj(k(j+1)).points(1,2),traj(k(j+1)).points(1,1),'r*')
%                     else
%                     plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)],[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)],'b-')
%                     end
                end
            end
        end
    end
end
hold off
% disp(sprintf('Number of groups %d',grNb));