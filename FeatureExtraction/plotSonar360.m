function [ output_args ] = plotSonar360( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global bufferISAux
x=[];
y=[];
z=[];
for i=1:200
    theta = bufferISAux(i,1);
    for k=5:504
        rho = ((k-4)*0.1);
        [xa,ya] = pol2cart(theta,rho);
        x = [x,xa];
        y = [y,ya];
        %z = [z,0]; %intensidade
        z = [z,bufferISAux(i,k)]; %intensidade
    end
end
    
figure2 = figure
scatter(x,y,20,z)
% saveas(figure1,a)
hold on;





end

