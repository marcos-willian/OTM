function newB=revers(newbeeA,bee_i_A,map)

n1=unidrnd(map.n); %random selection of the first member's place of the colony - n1
Kn=[1:n1-1 n1+1:map.n]; %preventing n1 from being selected
n2=Kn(randi([1 numel(Kn)])); %random selection of the second member's place of the colony - n2

% reversion process
if n1<n2
    newbeeA(n1:n2)=bee_i_A(n2:-1:n1);
else
    newbeeA(n1:-1:n2)=bee_i_A(n2:n1);
end

newB = newbeeA;

end