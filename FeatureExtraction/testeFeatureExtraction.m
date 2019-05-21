x = [-0.5 0.5 -0.5];
y = [0.3 0 -0.3];

veh = [x;y];

fig=figure;
h = patch(veh(1,:),veh(2,:),'y')
axis equal
hold on 
%

xl = [7;7];
yl = [2;4];


%Posicao do veiculo
xV = 2.5;
yV = 4.5;
phiV = deg2rad(0);

%local maxima bin simulado
thetaS = deg2rad(95); %angulo do bin
pS = 7; %ditancia do bin - na leitura dividir por 10

% fig = figure
% plot(xV,yV)
% hold on
[xr,yr] = reta(thetaS,pS,2);
axis equal
plot(xr,yr)

drawnow;