function newB=insert(newbeeA,bee_i_A,map)

n1=unidrnd(map.n); %random selection of the first member's place of the colony - n1
Kn=[1:n1-1 n1+1:map.n]; %preventing n1 from being selected
n2=Kn(randi([1 numel(Kn)])); %random selection of the second member's place of the colony - n2

% insertion process
if n1<n2
    newbeeA=bee_i_A([1:n1-1 n1+1:n2 n1 n2+1:end]);
else
    newbeeA=bee_i_A([1:n2 n1 n2+1:n1-1 n1+1:end]);
end

newB = newbeeA;

end