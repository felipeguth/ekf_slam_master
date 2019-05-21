for k=1:size(vft,1)
   
   plot(vft(k,1),vft(k,2),'g+');
   hold on;     
    k
end





vetFeatures = [];
for i=1:size(vft,1)

    for j=1:size(take)
        if i == take(j)
            vetFeatures =[vetFeatures; vft(i,:)]; 
            plot(vft(i,1),vft(i,2),'b+');
            hold on;            
        end
    end
    
%i
%i;
end

i; 