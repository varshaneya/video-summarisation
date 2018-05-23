#Codes the representativeness, uniformity and interestingness of superframe segments
import numpy as np
from scipy import io as sio
from numpy import linalg as la
import gm_submodular as gm
from gm_submodular import example_objectives as ex
import os

class subm(gm.DataElement):
    Y=[]
    y_gt=[]
    budget=0
    
    def getCosts(self):
        return self.y_gt
        
    def getValues(self):
        global vidName,dataPath
        gtDict = sio.loadmat(dataPath+'/GT/'+vidName[0:len(vidName)-4]+'.mat')
        temp = gtDict['gt_score']
        del gtDict
        j=0
        for i in range(len(temp)):
            if temp[i] != 0:
                self.y_gt.append(float(temp[i]))
                self.Y.append(int(i))
                j = j +1
            if j== 5:
                print self.y_gt
                break;
        self.y_gt=np.array(self.y_gt)
        self.Y = np.array(self.Y)
        
    def __init__(self):
        global frCount
        self.budget=frCount/5
        self.getValues()

def representativeness(S):
    global frCount,allFeatures,superFrames
    
    print "rep"
    
    sum2 = 0
    sum1 =0
    
    noSeg = superFrames.shape[0]
    temp = np.zeros((1,noSeg))
    
    for i in range(allFeatures.shape[0]):
        allFeatures[i,:] = allFeatures[i,:]/la.norm(allFeatures[i,:],2)
    
    phantom = np.median(allFeatures,axis=0);
    
    medArray=np.zeros((noSeg,allFeatures.shape[1]))
    
    for j in range(noSeg):
        lb  = superFrames[j,0]
        ub = superFrames[j,1]
    
        if ub > allFeatures.shape[0]-1:
            ub = allFeatures.shape[0]-1
            
        medArray[j,:] = np.median(np.vstack([allFeatures[lb:ub,:],phantom]),axis=0)
        
    temp = []
    
    for i in range(frCount):
        for j in range(noSeg):
            temp.append((la.norm(medArray[j,:]-allFeatures[i,:],2))**2);
        sum1 = sum1 + la.norm(phantom-allFeatures[i,:],2)**2
        sum2 = sum2 + min(temp)
    
    return (lambda sum1,sum2:sum1-sum2)

def uniformity(S):
    global frCount,superFrames
    
    print 'uni'
    
    allFeatures1 = range(frCount)
    
    sum2 = 0
    sum1 =0
    
    noSeg = superFrames.shape[0]
    temp = np.zeros((1,noSeg))
    
    allFeatures1 = allFeatures1/la.norm(allFeatures,2)
    
    phantom = np.median(allFeatures1);
    
    medArray=[]
    
    for j in range(noSeg):
        lb  = superFrames[j,0]
        ub = superFrames[j,1]
    
        if ub > allFeatures1.shape[0]-1:
            ub = allFeatures1.shape[0]-1
            
        medArray.append(np.median(np.hstack([allFeatures1[lb:ub],phantom])))
        
    temp = []
    
    for i in range(frCount):
        for j in range(noSeg):
            temp.append((medArray[j]-allFeatures1[i])**2);
        sum1 = sum1 + (phantom-allFeatures1[i])**2
        sum2 = sum2 + min(temp)
    
    return (lambda X:sum1-sum2)


def interestingness(S):
    global segInterestingness
    print 'int'
    return (lambda segInterestingness:sum(segInterestingness))
    
def intHelper(S):
    return lambda S:interestingness(S)

def repHelper(S):
    return lambda S:representativeness(S)

def uniHelper(S):
    return lambda S:uniformity(S)

frCount = 0
vidName=''
dataPath='../data'
segInterestingness = []
superFrames = []
allFeatures = []

gm.logger.setLevel('INFO')
#shells=[intHelper,repHelper,uniHelper]
shells=[interestingness,representativeness,uniformity]
print shells[0]

wtSubMod = dict()
wtSubMod['wtInt']=0
wtSubMod['wtRep']=0
wtSubMod['wtUni']=0

dirs = os.listdir('../sumMe/videos/')


for fil in dirs:
    if fil == 'Notre_Dame.mp4':
        continue
    vidName=fil
    
    intDict = sio.loadmat(dataPath+'/interestingness/'+vidName[0:len(vidName)-4]+'.mat')
    segInterestingness = np.array(intDict['segInterestingness'])
    
    sfDict = sio.loadmat(dataPath + '/superFrames/' + vidName[0:len(vidName)-4] + '.mat')
    superFrames = sfDict['superFrames']
    
    featuresDict = sio.loadmat(dataPath+'/featuresSumMe/'+vidName[0:len(vidName)-4]+'Features.mat')
    allFeatures = np.array(featuresDict['allFeatures'])
    frCount = int(featuresDict['frCount'])
    
    del intDict,sfDict,featuresDict
    
    S = subm()
    training_examples = []
    training_examples.append(S)
    
    loss=ex.intersect_complement_loss
    params=gm.SGDparams(use_l1_projection=True,max_iter=10,use_ada_grad=True)
    
    print "learning weights"
    params.max_iter=1
    print params
    learnt_weights,_=gm.learnSubmodularMixture(training_examples, shells,loss,params=params)
    
    wtSubMod['wtInt']+=learnt_weights[0]
    wtSubMod['wtRep']+=learnt_weights[1]
    wtSubMod['wtUni']+=learnt_weights[2]
    print fil
    break

#wtSubMod['wtInt']/=len(dirs)
#wtSubMod['wtRep']/=len(dirs)
#wtSubMod['wtUni']/=len(dirs)

print wtSubMod

sio.savemat('wtSubModFn',wtSubMod)

    
