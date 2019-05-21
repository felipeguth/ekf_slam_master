
x = [0 0 1];
y = [0.3 -0.3 0];

veh = [x;y];

a = [1 3];
b = [4 5];

fig=figure;
h = patch(veh(1,:),veh(2,:),'y')
hold on, axis equal
plot(a,b);

i = 1;
angleAnt = 0.0;

for i=1:length(VarName5)
   %angle = MTi(i,4) %HOME  
   angle = VarName5(i)     %linux FURG
   rot = angle - angleAnt
   
   rotate(h,[0,0,1],rot);
   
   angleAnt = angle;
   pause(0.001);
end