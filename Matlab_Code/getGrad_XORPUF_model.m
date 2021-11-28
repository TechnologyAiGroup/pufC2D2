
function grad = getGrad_XORPUF_model(theta,P,Y,nXOR)

    % theta: a matrix of model parameters. each row represents the 
    % parameters for each APUF.
    % P: feature matrix for individual APUF. 
    % All arbiter PUFs have same features values
    % Y: is target response [-1,1]
    % nXOR: # of APUF to XORed
    
    nChal = size(P,1);
    nFeaturesPerAPUF = size(P,2);
    theta = vec2mat(theta, nFeaturesPerAPUF);
    
    Ypred = getResponse_XORPUF_model(P,theta,nXOR);
    
    yy = Ypred - (Y+1)/2;
    wx = zeros(nChal,nXOR);
    for i=1:nXOR
        wx(:,i) = P * theta(i,:)' ; 
    end
    prod_wx = prod(wx,2);
    
    grad = zeros(nXOR,nFeaturesPerAPUF);
    for i=1:nXOR
        wx_i = wx(:,i);
        for j=1:nFeaturesPerAPUF
            grad(i,j) = sum((yy.*(P(:,j)./wx_i)).*prod_wx);
        end
    end  
    
    grad = reshape(grad',1,nFeaturesPerAPUF*nXOR);
end