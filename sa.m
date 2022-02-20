% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
% Project Code: YPEA105
% Project Title: Simulated Annealing for Traveling Salesman Problem
% Publisher: Yarpiz (www.yarpiz.com)
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
  clear;
  close all;
  tic
  better = inf;
  bestCostV = [];
  itV = [];
  loops = 10;
  showprogress = false;
  if showprogress
      loops = 1;
  end
for vez = 1:loops
  
% Problem Definition
  model=CreateModel();    % Create Problem Model

  CostFunction=@(tour) TourLength(tour,model);    % Cost Function

% SA Parameters
  MaxIt=500;      % Maximum Number of Iterations
  MaxSubIt=15;    % Maximum Number of Sub-iterations
  T0=0.025;       % Initial Temp.
  alpha=0.99;     % Temp. Reduction Rate

% Initialization

% Create and Evaluate Initial Solution
sol.Position=CreateRandomSolution(model);
sol.Cost=CostFunction(sol.Position);

% Initialize Best Solution Ever Found
BestSol=sol;

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Intialize Temp.
T=T0;

%SA Main Loop
    it = 0;
    stayed = 0;
    while it < MaxIt && stayed<100
        it = it + 1; 
        for subit=1:MaxSubIt
            
            % Create and Evaluate New Solution
            newsol.Position=CreateNeighbor(sol.Position);
            newsol.Cost=CostFunction(newsol.Position);
            
            if newsol.Cost<=sol.Cost % If NEWSOL is better than SOL
                sol=newsol;
                
            else % If NEWSOL is NOT better than SOL
                
                DELTA=(newsol.Cost-sol.Cost)/sol.Cost;
                
                P=exp(-DELTA/T);
                if rand<=P
                    sol=newsol;
                end
                
            end
            
            % Update Best Solution Ever Found
            if sol.Cost<=BestSol.Cost
                BestSol=sol;
            end
        
        end
        
        % Store Best Cost Ever Found
        BestCost(it)=BestSol.Cost;
        
        % Update Temp.
        T=alpha*T;
        
        % Plot Best Solution
        if showprogress
           % Show Iteration Information
             disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
              
           % Plot Solution
             figure(1);
             PlotSolution(BestSol.Position,model);
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
      bestRoute = BestSol.Position;
    end
end

%Results
disp(['Mean Time = ' num2str(toc/loops)]);
disp(['Mean Best Cost = ' num2str(mean(bestCostV)) ' SD = ' num2str(std(bestCostV))]);
disp(['Mean Iteration = ' num2str(mean(itV)) ' SD = ' num2str(std(itV))]);

% Plot Solution
figure(1);
PlotSolution(bestRoute, model);
