clear;
close all;
tic
  better = inf;
  bestCostV = [];
  loops = 10;
  showprogress = false;
  if showprogress
      loops = 1;
  end
for vez = 1:loops
    %function [ globalMin, optEngy, optRoute] = tsp_ga_basic(nStops, popSize, numIter, xy  )
    % FUNCTION:calculates the minimum tsp route distance for a
    % set of xy points.  The GA initializes the population using a random mix
    % of greedy algorithm and random permutation
    
    % GA uses uses a tournament approach mutation type genetic algorithm.  
    %  Initialize:
    %  (1) Calculate the distance from each xy coordinate to every other xy
    %  coordinate as distance matrix dmat.
    %  Body:
    %  (1) Randomly generate populations 
    %  (2) Find min-cost of all pop (trials); keep best pop member and plot.
    %  (3) Shuffle (reshuffle) pop for a new tournament
    %  (4) Sub-group pop into groups of 4.
    %      Find the best of the 4; Overwrite worst of 4 from sub-group pop
    %  (5) Mutate the best of 4 (winner) in each sub-group
    %  (6) Insert best of 4 (winner) and all mutations back into population
    %  (7) If iteration budget remains, go to step 2, else terminate.
    %  Termination: based on iteration budget.
    % 
    %  Useage:  
    % 
    % inputs:
    nStops  = 50;      % Number of delivery stops for blimp-drone
    popSize = 400;  % Size of the population of trials.
    numIter = 500; % Number of iterations of GA; iteration budget.
    X_AND_Y;
    model.x = x;
    model.y = y;
    xy(:,1) = x';
    xy(:,2) = y';

    
    truck_energy_km = 10.5e6;
    % initialize variables to integers/standard size, create distance matrix
    nPoints = size(xy,1);
    popSize     =  5*floor(popSize/5);
    numIter     =  max(1,round(real(numIter(1))));
    iterHist    = zeros(1,numIter);
    meshg = meshgrid(1:nPoints);
    dmat = reshape(sqrt(sum((xy(meshg,:)-xy(meshg',:)).^2,2)),nPoints,nPoints);
    maxd = max(max(dmat))*100;
    % Initialize the Population
    [n, ~]=  size(xy);
    pop = zeros(popSize,n);
    pop(1,:) = (1:n); oc=0;
    for k=2:popSize
       % greedy population construction
       if k<n+1
         dmat2=dmat;
         rp=k-1;
         pop(k,1)=rp(1); c=1;
         for i=1:n
           dmat2(i,i)=maxd;
         end
         for i=1:n-1
               [~, mid]=min(dmat2(pop(k,c),1:n));
               dmat2(pop(k,c),:)=maxd; 
               dmat2(:,pop(k,c))=maxd;
               c=c+1; pop(k,c)=mid;
         end
       else
     % random population construction
           pop(k,:)=randperm(n);
       end
    end
        
    % Run the GA
    globalMin = Inf;
    totalDist = zeros(1,popSize);
    totalEngy = zeros(1,popSize);
    distHistory = zeros(1,numIter);
    tmpPop = zeros(5,n);
    newPop = zeros(popSize,n);
    iter = 0;
    stayed = 0;
    while iter < numIter && stayed<100
        iter = iter + 1;
        % Evaluate Each Population Member (Calculate Total Distance)
        for p = 1:popSize
            d = dmat(pop(p,n),pop(p,1)); % Closed Path (last back to first) dist
            for k = 2:1:n   % dist cities 1 to n
                d = d + dmat(pop(p,k-1),pop(p,k)); % Distances of city 1 to n
            end
            eng = d*truck_energy_km;
            totalEngy(p) = eng;
            totalDist(p) = d;  % total distance for each random population
       end
        
        % Find the Best Route in the Population
        [minDist,index] = min(totalDist);
        distHistory(iter) = minDist;
        if minDist < globalMin
            globalMin  = minDist;
            optRoute    = pop(index,:);
            optEngy     = totalEngy(index);
    
            if showprogress
               oc=oc+1;
               iterHist(oc) = iter;
               RT = [optRoute optRoute(1)];
               subplot(1,2,1)
               plot( xy(:,1), xy(:,2), 'r.'); hold on;
               plot( xy(RT,1), xy(RT,2),'k-.'); hold off;
               
               %title(sprintf('TSP cost = %1.1f Energy = %1.1f MJ ',minDist, optEngy/1e6));
                title(sprintf('TSP Distance = %1.1f ',minDist));
                if iter>1
                      subplot(1,2,2)
                      ih = iterHist(1:oc);
                      plot(ih, distHistory(ih),'k-+'); 
                      title(sprintf('Convergence: Min Cost = %1.4f',minDist));
                      xlabel('iter'); ylabel('Cost');
                end
               hold off;
               drawnow;
            end
            
        end
        
        % Genetic Algorithm Operators
        randomOrder = randperm(popSize);
    
        for p = 5:5:popSize
                % basically a random sampling in matrix format with a 
            rtes = pop(randomOrder(p-4:p),:); 
            dists = totalDist(randomOrder(p-4:p));
                % what are the min distances?
            [~,idx] = min(dists); 
                % what is the best route
            bestOf5Route = rtes(idx,:);
                % randomly select two route insertion points and sort
            routeInsertionPoints = sort(ceil(n*rand(1,2))); adj=floor(.80*n);
            routeInsertionPoints2 = sort( [randi(max(1,n-adj),[1 1]), randi(max(1,adj),[1 1])]);
                I = routeInsertionPoints(1);
                J = routeInsertionPoints(2);
                L = routeInsertionPoints2(1);
                M = routeInsertionPoints2(2)+L;
            for k = 1:5 % Mutate the Best row (dist) to get Three New Routes and orig.
                % a small matrix of 4 rows of best time
                tmpPop(k,:) = bestOf5Route;
                switch k
                       % flip two of the cities and cities between
                    case 2 % Flip
                        tmpPop(k,I:J) = tmpPop(k,J:-1:I);
                    case 3 % Swap
                        tmpPop(k,[I J]) = tmpPop(k,[J I]);
                    case 4 % Slide or Sort
                       tmpPop(k,I:J) = tmpPop(k,[I+1:J I]);
                    case 5 % Slide or Sort
                       tmpPop(k,[L M]) = tmpPop(k,[M L]);
                    otherwise % Do Nothing
                end
            end
             % using the original population, create a new population
            newPop(p-4:p,:) = tmpPop;
        end
        pop = newPop;  
        if iter > 1
            if distHistory(iter) == distHistory(iter - 1)
              stayed = stayed + 1;
            else
              stayed = 0;
            end
        end
    end
    bestCostV(vez) = globalMin;
    itV(vez) = iter;
    if bestCostV(vez) < better
      bestRoute = optRoute;
    end

end
% Results
disp(['Mean Time = ' num2str(toc/loops)]);
disp(['Mean Best Cost = ' num2str(mean(bestCostV)) ' SD = ' num2str(std(bestCostV))]);
disp(['Mean Iteration = ' num2str(mean(itV)) ' SD = ' num2str(std(itV))]);

% Plot Solution
figure(1);
PlotSolution(bestRoute, model);











