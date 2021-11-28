
clear all;
clc;

Xpw_number=1;   %number of regenerated XOR PUF models 

Iscover=true;   %whether to regenerate XOR PUF weights

Isrepeat=true;  %whether to regenerate the test set and training set


repeatnum=1;
compareAccuracyresult=[];
chalSize1 = 64;    % Bit length of challenge
mu = 0;           % Mean of variation in delay parameters
sigma = 0.05;        % Standard deviation of variation in delay parameters
x =2;             % x - number of APUFs in x-XOR PUF

%generate challenge and response matricies 
nGeneration = 3000; %size of train set
nTest=1000;
for epoch=1:Xpw_number
    count=0;
    if Iscover==true
        %generate x-XOR PUF
        x_XPw = XORPUFgeneration(x,chalSize1,mu,sigma);
        filename="x_XPw_chal"+chalSize1+"_"+x+"APUF"+"_epoch"+epoch+".csv";
        csvwrite(filename,x_XPw);
        filenameXpw=filename;
    end   
    for chalgen=1:repeatnum
        if Isrepeat==true
            filename="x_XPw_chal"+chalSize1+"_"+x+"APUF"+"_epoch"+epoch+".csv";
            filenameXpw=filename;
            
            [Testchal,Testres]=GenTestSet(filenameXpw,nTest,chalSize1,epoch,x);
            
            challenge= sampling(0,1,nGeneration,chalSize1); 
            filenamechal="chal"+chalSize1+"_trainsize"+nGeneration+"_repeatnum"+chalgen+"_epoch"+epoch+"_"+x+"APUF"+".csv";
            csvwrite(filenamechal,challenge);
            challengePhi = Transform(challenge, nGeneration, chalSize1);
            challengePhi = fliplr(challengePhi);
            filenamexpw="x_XPw_chal"+chalSize1+"_"+x+"APUF"+"_epoch"+epoch+".csv";
            x_XPw = csvread(filenamexpw);
            response = ComputeResponseXOR(x_XPw,x,challengePhi,nGeneration,chalSize1+1);
            nAPUF = x; 
            
            nChal = nGeneration;            % Number of challenges
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
            filenameres="response"+"_trainsize"+nGeneration+"_repeatnum"+chalgen+"_epoch"+epoch+"_"+x+"APUF"+".csv";
            csvwrite(filenameres,R);          
        end
    end   
end




