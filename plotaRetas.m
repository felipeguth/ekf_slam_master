figure
plot(XX(1), XX(2));
hold on
[x,y] = pol2cart(XX(9), XX(10));
[xr, yr] = reta(x,y,5);
plot(xr, yr)
axis equal

figure
plot(XX(1),XX(2));%robot position
hold on
xr = [3;4];
yr = [4;5];
plot(xr, yr);
axis([0 8 0 8]);