function [ ] = drawBestTour(colony , map)

queenTour = colony;
hold on
for i = 1 : length(queenTour) - 1
    
    currentNode = queenTour(i);
    nextNode =  queenTour(i+1);
    
    x1 = map.node(currentNode).x;
    y1 = map.node(currentNode).y;
    
    x2 = map.node(nextNode).x;
    y2 = map.node(nextNode).y;
    
    X = [x1 , x2];
    Y = [y1, y2];
    plot (X, Y, '-k');

end

for i = 1 : map.n
    
    X = [map.node(:).x];
    Y = [map.node(:).y];
    
    plot(X, Y, 'ok', 'markerSize' , 3 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor', [1, 0.6, 0.6]);
end

title('Best Tour')
box('on');