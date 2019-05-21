str = sprintf('guth.log');
format long;
fid=fopen(str);
Dados=textscan(fid,'%f %f %f %f %f %f %f %f %f %f');
for j=1:3342
    round(Dados{2}(j)/100)+(mod(Dados{2}(j),100)/60);
    dlat(j) = deg2rad(ans);
    round(Dados{3}(j)/100)+(mod(Dados{3}(j),100)/60);
    dlon(j) = deg2rad(ans);
    dalt(j) = Dados{5}(j);
    Rn(j)=6378137/(sqrt(1-0.00669437999014*(sin(dlat(j)))^2));
    X(j)=(Rn(j)+dalt(j))*cos(dlat(j))*cos(dlat(j));
    Y(j)=(Rn(j)+dalt(j))*cos(dlat(j))*sin(dlon(j));
end
A(1)=0;
B(1)=0;
for j=2:3342
    A(j)=(X(j)-X(j-1)+A(j-1));
    B(j)=Y(j)-Y(j-1)+B(j-1);
end
A = -1 * A;
%B = -1* B;
plot(A,B)
hold on;
grid on;
axis;
