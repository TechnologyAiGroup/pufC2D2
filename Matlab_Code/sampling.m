%
%Generate a non-repetitive challenge set
%

function s=sampling(low,up,m,n)
    % m: The column size of the challenge set
    % n: The row size of each challenge
  nGeneration = m; %size of test set
  challenge= randi([low up], nGeneration, n);
  
  %unique the array challenge
  classNo = unique(challenge,'rows');
  count=size(classNo,1);
  
  while size(classNo,1)<m
      t1= randi([low up], 1, n);
      %determine whether to repeat
      [tfa,~] = ismember(t1,classNo,'rows');
      if tfa==1
          continue;
      else
        classNo(count+1,:)=t1(1,:);
        count=count+1;
      end     
  end
  s=classNo;
  
end