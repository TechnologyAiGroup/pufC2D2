

% This function will compute the response for given challenges of 
% a XOR-APUF model.

function response = getResponse_XORPUF_model(challenge,theta_xor,nXOR)

    % challenge: Challenge for XOR-APUF
    % theta_xor: matrix of model parameter for XOR-APUF. Each row 
    % is the model parmaters for individual PUF.
    % nXOR: # of APUF to be XORed
    
    nChal = size(challenge,1); 
    nFeaturesPerAPUF = size(challenge,2);
    indivAPUF_response = zeros(nChal,nXOR);
    theta_xor = vec2mat(theta_xor, nFeaturesPerAPUF);
    for i=1:nXOR
        theta = theta_xor(i,:);
        indivAPUF_response(:,i) = challenge * theta';  % compute WX' of each APUF
    end
    
    gx = prod(indivAPUF_response,2);                   % compute the product of WX' of each APUF
    response = sigmiod_fn(gx);                         % response in range [-1,1]
    
end
