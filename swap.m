function newB=swap(newbeeA,bee_i_A,map)

n1=unidrnd(map.n); %random selection of the first member's place of the colony - n1
Kn=[1:n1-1 n1+1:map.n]; %preventing n1 from being selected
n2=Kn(randi([1 numel(Kn)])); %random selection of the second member's place of the colony - n2

% swap process
newbeeA(n1)=bee_i_A(n2);
newbeeA(n2)=bee_i_A(n1);

newB = newbeeA;

end