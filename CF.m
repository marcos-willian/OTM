function t_length=CF(A,map)

t_length=0;
l_n=map.n;
for i=1:l_n-1
s_length=map.edges(A(i),A(i+1));
t_length=t_length+s_length;
end
t_length=t_length+map.edges(A(l_n),A(1));
end