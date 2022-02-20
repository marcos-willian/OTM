% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
% Project Code: YOEA103
% Project Title: Ant Colony Optimization for Traveling Salesman Problem
% Publisher: Yarpiz (www.yarpiz.com)
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team) 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
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
% Problem Definition
  model = CreateModel();
  CostFunction=@(tour) TourLength(tour,model);
  nVar=model.n;
% ACO Parameters
  MaxIt=500;      % Maximum Number of Iterations
  nAnt=40;        % Number of Ants (Population Size)
  Q=1;
  tau0=10*Q/(nVar*mean(model.D(:)));	% Initial Phromone
  alpha=1;        % Phromone Exponential Weight
  beta=1;         % Heuristic Exponential Weight
  rho=0.05;       % Evaporation Rate
% Initialization
  eta=1./model.D;             % Heuristic Information Matrix
  tau=tau0*ones(nVar,nVar);   % Phromone Matrix
  BestCost=zeros(MaxIt,1);    % Array to Hold Best Cost Values
% Empty Ant
  empty_ant.Tour=[];
  empty_ant.Cost=[];
% Ant Colony Matrix
  ant=repmat(empty_ant,nAnt,1);
  % Best Ant
  BestSol.Cost=inf;
% ACO Main Loop
  it = 0;
  stayed = 0;
  while it < MaxIt && stayed<100
    it = it + 1;  
    % Move Ants
      for k=1:nAnt
          ant(k).Tour=randi([1 nVar]);
          for l=2:nVar
              i=ant(k).Tour(end);
              P=tau(i,:).^alpha.*eta(i,:).^beta;
              P(ant(k).Tour)=0;
              P=P/sum(P);
              j=RouletteWheelSelection(P);
              ant(k).Tour=[ant(k).Tour j];
          end
          ant(k).Cost=CostFunction(ant(k).Tour);
          if ant(k).Cost<BestSol.Cost
              BestSol=ant(k);
          end
      end
    % Update Phromones
      for k=1:nAnt
          tour=ant(k).Tour;
          tour=[tour tour(1)]; %#ok
          for l=1:nVar
              i=tour(l);
              j=tour(l+1);
              tau(i,j)=tau(i,j)+Q/ant(k).Cost;
          end  
      end  
    % Evaporation
      tau=(1-rho)*tau;
      
    % Store Best Cost
      BestCost(it)=BestSol.Cost;
      if showprogress
        % Show Iteration Information
          disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
          
        % Plot Solution
          figure(1);
          PlotSolution(BestSol.Tour,model);
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
      bestRoute = BestSol.Tour;
  end
% Results
end
disp(['Mean Time = ' num2str(toc/loops)]);
disp(['Mean Best Cost = ' num2str(mean(bestCostV)) ' SD = ' num2str(std(bestCostV))]);
disp(['Mean Iteration = ' num2str(mean(itV)) ' SD = ' num2str(std(itV))]);
  
% Plot Solution
figure(1);
PlotSolution(bestRoute, model);
  
