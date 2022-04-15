clear all;
clc;

Xpw_number=10;     %The number of times to regenerate the weight value
Iscover=true;     %whether to regenerate weights

Isrepeat=true;   %whether to regenerate challenge
repeatnum=1;

chalSize1 = 128;    % Bit length of challenge
mu = 0.1;           % Mean of variation in delay parameters
sigma = 1;        % Standard deviation of variation in delay parameters
x =5;             % x - number of APUFs in x-XOR PUF

%generate challenge and response matricies 
nGeneration = 100000; %size of train set

number=nGeneration/1000;
nTest=2000;
nTotal=nGeneration+200;
allac=[];
for epoch=Xpw_number:Xpw_number
    count=0;
    if Iscover==true
        %generate x-XOR PUF
        x_XPw = XORPUFgeneration(x,chalSize1,mu,sigma);
        filename="x_XPw_chal"+chalSize1+"_"+x+"APUF"+"_epoch"+epoch+".csv";
        csvwrite(filename,x_XPw);
%         x_XPw=csvread(filename);
    end   
    for chalgen=1:repeatnum
        if Isrepeat==true
      
           challenge= sampling(0,1,nGeneration,chalSize1);
            
            CurPCAVector=getPCAVector(challenge);
            filenamechal="chal"+chalSize1+"_trainsize"+nGeneration+"_repeatnum"+chalgen+"_epoch"+epoch+"_"+x+"APUF"+".csv";
            csvwrite(filenamechal,challenge);
            challengePhi = Transform(challenge, nGeneration, chalSize1);
            
            challengeParity=challengePhi;
            csvwrite("APUF_"+x+"_XOR_Challenge_Parity_"+chalSize1+"_"+number+"k_"+Xpw_number+".csv",challengeParity);
            challengePhi = fliplr(challengePhi);
            filenamexpw="x_XPw_chal"+chalSize1+"_"+x+"APUF"+"_epoch"+epoch+".csv";
            response = ComputeResponseXOR(x_XPw,x,challengePhi,nGeneration,chalSize1+1);
            % Number of APUFs are being XORed
            nAPUF = x; 


            nChal = nGeneration;        % Number of challenges
            C = challenge(1:nChal,:);
            Resp = response(1:nChal,:);
            clear challenge response;
            chalSize = size(C,2);      % Bit-length of challenge

            % Compute the XORAPUF output
            R = zeros(nChal,1);   % Response of XORAPUF 
            for k=1:nAPUF
                Rk = Resp(:,k);
                R = double(xor(Rk,R));
            end
            csvwrite(x+"-xorpuf_"+chalSize1+"_"+number+"k_"+Xpw_number+".csv",R);          
        end
        
        train_pca=[challengeParity CurPCAVector];
        csvwrite("PCA_"+x+"APUF_XOR_Challenge_Parity_"+chalSize1+"_"+number+"k_"+Xpw_number+".csv",train_pca);
            
        
    end
    
end