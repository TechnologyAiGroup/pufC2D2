
function [Y P] = classify(X,theta_xor,nXOR) 

    nChal = size(X,1); 
    nFeaturesPerAPUF = size(X,2);
    indivAPUF_response = zeros(nChal,nXOR);
    theta_xor = vec2mat(theta_xor, nFeaturesPerAPUF);
    for i=1:nXOR
        theta = theta_xor(i,:);
        indivAPUF_response(:,i) = X * theta';  % compute WX' of each APUF
    end
    
    gx = prod(indivAPUF_response,2);                   % compute the product of WX' of each APUF
    P = sigmiod_fn(gx);                                % response in range [-1,1]
    Y = P > 0.5;
    
end