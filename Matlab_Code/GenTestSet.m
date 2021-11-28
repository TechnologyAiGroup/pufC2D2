%Generate the Test Set for XORPUF 
%filenameXpw: the instance weight of the XORPUF
%nGeneration:the size of the test set
%chalSize1:the bits of XORPPUF
%epoch:the Serial number of the generated XORPUF
%x:Number of APUFs are being XORed

function [filenamechal,filenameres]=GenTestSet(filenameXpw,nGeneration,chalSize1,epoch,x)
            challenge= sampling(0,1,nGeneration,chalSize1);
            filenamechal="chal"+chalSize1+"_Testsize"+nGeneration+"_epoch"+epoch+"_"+x+"APUF"+".csv";
            csvwrite(filenamechal,challenge);
            challengePhi = Transform(challenge, nGeneration, chalSize1);
            challengePhi = fliplr(challengePhi);
            filenamexpw=filenameXpw;
          
            % C[0], C[1], ...., C[n-1]
            x_XPw = csvread(filenamexpw);
            response = ComputeResponseXOR(x_XPw,x,challengePhi,nGeneration,chalSize1+1);
            % Number of APUFs are being XORed
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
            filenameres="response"+"_Testsize"+nGeneration+"_epoch"+epoch+"_"+x+"APUF"+".csv";
            csvwrite(filenameres,R);      


end