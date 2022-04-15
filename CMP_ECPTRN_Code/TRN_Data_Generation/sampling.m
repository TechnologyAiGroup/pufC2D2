function s=sampling(low,up,m,n)
  nGeneration = m; %size of test set
  challenge= randi([low up], nGeneration, n);
  classNo = unique(challenge,'rows');
  count=size(classNo,1);
  while size(classNo,1)<m
      t1= randi([low up], 1, n);
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