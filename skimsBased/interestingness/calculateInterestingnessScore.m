noOfParam = 8;
numCol = 1+noOfParam+((noOfParam-1)*noOfParam/2);

if ~exist('dataPath','var')
    dataPath='../data';
end

if isTraining == 1
load(fullfile(dataPath,'aesthetics',vidName),'colour','cont','quality');
load(fullfile(dataPath,'faceDetection',vidName),'face','person','frCount');
load(fullfile(dataPath,'staticAttention',vidName),'staticAttention');
load(fullfile(dataPath,'temporalAttention',vidName),'temporalAttention');
load(fullfile(dataPath,'superFrames',vidName),'superFrames');
load(fullfile(dataPath,'complexity',vidName),'imgCompl');
end

minval1 = min([length(colour),length(cont),length(quality),length(temporalAttention)]);
minval2 = min([frCount,length(face),length(person),length(staticAttention)]);

if ~exist('isEvaluate','var') && ~exist('leaveOut','var')
    load(fullfile(dataPath,'interestingness','weights.mat'),'wt');
else
    load(fullfile('interestingness',['weights' num2str(leaveOut) '.mat']),'wt');
end


if minval1 > length(temporalAttention)
    temporalAttention = [0 temporalAttention];
end

interestingness = [];

if isSubModOptimisiation==0
noSeg = size(superFrames,1);
for i =1:noSeg
    lb  = superFrames(i,1); 
    ub = superFrames(i,2);
    
    if ub>minval2      %frCount-1
        ub = minval2;
    end
    
    frNos1 = lb:ub;
    frNos2 = ceil(frNos1./5);
    frNos2(frNos2==0)=1;
    frNos2(frNos2>minval1)=minval1;    %length(colour)
    
    A = ones(ub-lb+1,numCol);
    
A(:,2) = colour(frNos2)';
A(:,3) = cont(frNos2)';
A(:,4) = quality(frNos2)';
A(:,5) = face(frNos1)';
A(:,6) = person(frNos1)';
A(:,7) = staticAttention(frNos1)';
A(:,8) = temporalAttention(frNos2)';
A(:,9) = imgCompl(frNos1)';

A(:,10) = colour(frNos2)' .* cont(frNos2)';
A(:,11) = colour(frNos2)' .* quality(frNos2)';
A(:,12) = colour(frNos2)' .* face(frNos1)';
A(:,13) = colour(frNos2)' .* person(frNos1)';
A(:,14) = colour(frNos2)' .* staticAttention(frNos1)';
A(:,15) = colour(frNos2)' .* temporalAttention(frNos2)';
A(:,16) = colour(frNos2)' .* imgCompl(frNos1)';

A(:,17) = cont(frNos2)' .* quality(frNos2)';
A(:,18) = cont(frNos2)' .* face(frNos1)';
A(:,19) = cont(frNos2)' .* person(frNos1)';
A(:,20) = cont(frNos2)' .* staticAttention(frNos1)';
A(:,21) = cont(frNos2)' .* temporalAttention(frNos2)';
A(:,22) = cont(frNos2)' .* imgCompl(frNos1)';

A(:,23) = quality(frNos2)' .* face(frNos1)';
A(:,24) = quality(frNos2)' .* person(frNos1)';
A(:,25) = quality(frNos2)' .* staticAttention(frNos1)';
A(:,26) = quality(frNos2)' .* temporalAttention(frNos2)';
A(:,27) = quality(frNos2)' .* imgCompl(frNos1)';

A(:,28) = face(frNos1)' .* person(frNos1)';
A(:,29) = face(frNos1)' .* staticAttention(frNos1)';
A(:,30) = face(frNos1)' .* temporalAttention(frNos2)';
A(:,31) = face(frNos1)' .* imgCompl(frNos1)';

A(:,32) = person(frNos1)' .* staticAttention(frNos1)';
A(:,33) = person(frNos1)' .* temporalAttention(frNos2)';
A(:,34) = person(frNos1)' .* imgCompl(frNos1)';

A(:,35) = staticAttention(frNos1)' .* temporalAttention(frNos2)';
A(:,36) = staticAttention(frNos1)' .* imgCompl(frNos1)';

A(:,37) = temporalAttention(frNos2)'.*imgCompl(frNos1)';

b = A*wt;

clear A

segInterestingness(i) = sum(b);
%interestingness = [interestingness b'];
end

elseif isSubModOptimisiation==1
   frNos1 = 1:minval2;    %frCount
    frNos2 = ceil(frNos1./5);
    frNos2(frNos2==0)=1;
    frNos2(frNos2>minval1)=minval1;    %length(colour)
    A = ones(minval2,numCol);
A(:,2) = colour(frNos2)';
A(:,3) = cont(frNos2)';
A(:,4) = quality(frNos2)';
A(:,5) = face(frNos1)';
A(:,6) = person(frNos1)';
A(:,7) = staticAttention(frNos1)';
A(:,8) = temporalAttention(frNos2)';
A(:,9) = imgCompl(frNos1)';

A(:,10) = colour(frNos2)' .* cont(frNos2)';
A(:,11) = colour(frNos2)' .* quality(frNos2)';
A(:,12) = colour(frNos2)' .* face(frNos1)';
A(:,13) = colour(frNos2)' .* person(frNos1)';
A(:,14) = colour(frNos2)' .* staticAttention(frNos1)';
A(:,15) = colour(frNos2)' .* temporalAttention(frNos2)';
A(:,16) = colour(frNos2)' .* imgCompl(frNos1)';

A(:,17) = cont(frNos2)' .* quality(frNos2)';
A(:,18) = cont(frNos2)' .* face(frNos1)';
A(:,19) = cont(frNos2)' .* person(frNos1)';
A(:,20) = cont(frNos2)' .* staticAttention(frNos1)';
A(:,21) = cont(frNos2)' .* temporalAttention(frNos2)';
A(:,22) = cont(frNos2)' .* imgCompl(frNos1)';

A(:,23) = quality(frNos2)' .* face(frNos1)';
A(:,24) = quality(frNos2)' .* person(frNos1)';
A(:,25) = quality(frNos2)' .* staticAttention(frNos1)';
A(:,26) = quality(frNos2)' .* temporalAttention(frNos2)';
A(:,27) = quality(frNos2)' .* imgCompl(frNos1)';

A(:,28) = face(frNos1)' .* person(frNos1)';
A(:,29) = face(frNos1)' .* staticAttention(frNos1)';
A(:,30) = face(frNos1)' .* temporalAttention(frNos2)';
A(:,31) = face(frNos1)' .* imgCompl(frNos1)';

A(:,32) = person(frNos1)' .* staticAttention(frNos1)';
A(:,33) = person(frNos1)' .* temporalAttention(frNos2)';
A(:,34) = person(frNos1)' .* imgCompl(frNos1)';

A(:,35) = staticAttention(frNos1)' .* temporalAttention(frNos2)';
A(:,36) = staticAttention(frNos1)' .* imgCompl(frNos1)';

A(:,37) = temporalAttention(frNos2)'.*imgCompl(frNos1)';


b = A*wt;
 
interestingness = [interestingness b'];
end

if isTraining == 1 && isSubModOptimisiation==0
save(vidName,'segInterestingness');
end

if isTraining == 1 && isSubModOptimisiation==1
save(vidName,'interestingness');
end
%end
%plot(B);

