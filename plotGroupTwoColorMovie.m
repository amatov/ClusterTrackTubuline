function h = plotGroupTwoColorMovie(traj,group)

grNb = length(group);
trNb = length(traj);


for i = 1:trNb

    plot(traj(i).points(:,1)*2,traj(i).points(:,2)*2,'w-','LineWidth',1)

end
for i = 1:grNb
    k = group(i).list;
    le_gr = length(k);
    if le_gr > 0
%         plot(traj(k(1)).points(1,1),traj(k(1)).points(1,2),'ks')
        hold on
        for j = 1:le_gr
%             plot(traj(k(j)).points(:,1)*2,traj(k(j)).points(:,2)*2,'w-','LineWidth',2) % PLOT ALL
            
            % Beginning TRACK
%             plot(traj(k(j)).points(end,1),traj(k(j)).points(end,2),'k*')
            % SEGMENT
%             plot([traj(k(j)).points(1,1),traj(k(j)).points(end,1)],[traj(k(j)).points(1,2),traj(k(j)).points(end,2)],'k:') 
            if j < le_gr
                if group(i).direction(j) == 1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)]*2,[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)]*2,'g-')
                    % Beginning GAP
%                     plot(traj(k(j+1)).points(1,1),traj(k(j+1)).points(1,2),'g*')
                elseif group(i).direction(j) == -1%INDEX?
                    plot([traj(k(j)).points(end,1),traj(k(j+1)).points(1,1)]*2,[traj(k(j)).points(end,2),traj(k(j+1)).points(1,2)]*2,'r-')
                    % Beginning SHRINK
%                     plot(traj(k(j+1)).points(1,1),traj(k(j+1)).points(1,2),'r*')
                end
            end
        end
    end
end
