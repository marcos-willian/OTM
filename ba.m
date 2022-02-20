clear;
close all;
tic
better = inf;
bestCostV = [];
itV = [];
loops = 5;
showprogress = false;
if showprogress
  loops = 1;
end
for vez = 1:loops
    % Bees Algorithm Parameters
    MaxIt=500;              % Maximum Number of Iterations
    nScoutBee=25;            % Number of Scout Bees
    nEliteSite=4;            % Number of Elite Sites 
    nBestSite=20;            % Number of Best Sites 
    nEliteSiteBee=300;       % Number of Recruited Bees for Elite Sites
    nBestSiteBee=100;        % Number of Recruited Bees for Best Sites
    
    %Initialization
    
    % Create the map 
    [map]=create_tsp_map();
    
    % Empty Bee Structure
    empty_bee.A=[];
    empty_bee.Cost=[];
    
    % Initialize Bees Array
    bee=repmat(empty_bee,nScoutBee,1);
    
    % Create First Population
    for i=1:nScoutBee
        bee(i).A=randperm(map.n);
        bee(i).Cost=CF(bee(i).A,map);
    end
    
    % Sort
    [~, SortOrder]=sort([bee.Cost]);
    bee=bee(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=bee(1);
    
    % Array to Hold Best Cost Values
    BestCost=zeros(MaxIt,1);
    
    % Bees Algorithm Main Loop
      it = 0;
      stayed = 0;
      while it < MaxIt && stayed<100
      it = it + 1; 
        for i=1:nEliteSite
            bestnewbee.Cost=inf;
            for j=1:nEliteSiteBee
            newbee.A=bee(i).A;
            lon=unidrnd(3);
            if lon==1
                newbee.A = swap(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            elseif lon==2
                newbee.A = revers(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            else
                newbee.A = insert(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            end
            end
            if bestnewbee.Cost<bee(i).Cost
                bee(i)=bestnewbee;
            end
        end
        
        for i=nEliteSite+1:nBestSite
            bestnewbee.Cost=inf;
            for j=1:nBestSiteBee
            newbee.A=bee(i).A;
            lon=unidrnd(3);
            if lon==1
                newbee.A = swap(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            elseif lon==2
                newbee.A = revers(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            else
                newbee.A = insert(newbee.A,bee(i).A,map);
                newbee.Cost = CF(newbee.A,map);
                if newbee.Cost<bestnewbee.Cost
                    bestnewbee=newbee;
                end
            end
            end
            if bestnewbee.Cost<bee(i).Cost
                bee(i)=bestnewbee;
            end
        end
        
        % Global search
        for i=nBestSite+1:nScoutBee
            bee(i).A=randperm(map.n);
            bee(i).Cost=CF(bee(i).A,map);
        end
        
        % Sort
        [~, SortOrder]=sort([bee.Cost]);
        bee=bee(SortOrder);
        
        % Update Best Solution Ever Found
        BestSol=bee(1);
        
        % Store Best Cost Ever Found
        BestCost(it)=BestSol.Cost;
        
        % Display Iteration Information
        if showprogress
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
            
              % online map 
            colony = [bee(1).A bee(1).A(1)]; 
            subplot(1,1,1)
            cla
            drawBestTour(colony, map);
            drawnow
        end
        if it > 1
          if BestCost(it) == BestCost(it - 1)
              stayed = stayed + 1;
          else
              stayed = 0;
          end
        end
    end
    bestCostV(vez) = BestCost(it);
    itV(vez) = it;
    if bestCostV(vez) < better
      bestRoute = BestSol.A;
    end
% Results
end
disp(['Mean Time = ' num2str(toc/loops)]);
disp(['Mean Best Cost = ' num2str(mean(bestCostV)) ' SD = ' num2str(std(bestCostV))]);
disp(['Mean Iteration = ' num2str(mean(itV)) ' SD = ' num2str(std(itV))]);
  
% Plot Solution
figure(1);
PlotSolution(bestRoute, map.model);


