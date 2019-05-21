global bufferIS linhaBuffer


%dados de referencia ultima leitura do sonar (nao necessariamente centésima
%dumbasss)

x_ref     = bufferIS(linhaBuffer-1,2);
y_ref     = bufferIS(linhaBuffer-1,3);
theta_ref = bufferIS(linhaBuffer-1,4);  


for l=1:100
    angulo = pi_to_pi(bufferIS(l,4)) + pi_to_pi(bufferIS(l,1)) + pi;

end



