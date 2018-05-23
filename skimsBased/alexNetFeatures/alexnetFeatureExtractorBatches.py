import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import caffe
import scipy.io as sio
import sys
import h5py as hp

def featureExt(net,data,count):
    temp = np.zeros((frCount,4096))
    
    for i in range(0,count):
	im = data[i,:,:,:] #load the image in the data layer
	net.blobs['data'].data[...] = transformer.preprocess('data', im)
	out = net.forward_all(data=np.asarray([transformer.preprocess('data', im)]))
	temp[:][i] = net.blobs['fc6'].data.copy()
    
    return temp

vidName = sys.argv[1]
directory = '../framesSumMe/'
noOfSeg = int(sys.argv[2])

net = caffe.Net('deploy.prototxt','bvlc_alexnet.caffemodel',caffe.TEST)

transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_mean('data', np.load('python/caffe/imagenet/ilsvrc_2012_mean.npy').mean(1).mean(1))
transformer.set_transpose('data', (2,0,1))
transformer.set_channel_swap('data', (2,1,0))
transformer.set_raw_scale('data', 255.0)

net.blobs['data'].reshape(1,3,227,227)
#net.blobs['data'].reshape(*data[0,:,:,:].shape)

features = dict()
features['frCount'] = 0
frCount = 0
temp = np.zeros((frCount,4096))

"""
f = hp.File(directory + vidName + str(i+1) + '.mat','r')
data = np.array(f.get('allFrames'))
frCount = int(f.get('frCount')[0][0])
features['frCount'] += frCount
temp = featureExt(net,data,frCount)
"""

for i in range(0,noOfSeg):
    f = hp.File(directory + vidName + str(i+1) + '.mat','r')
    data = np.array(f.get('allFrames'))
    frCount = int(f.get('frCount')[0][0])
    features['frCount'] += frCount
    if i ==0:
        temp = featureExt(net,data,frCount)
    else:
        temp = np.vstack((temp,featureExt(net,data,frCount)))
    print 'segment ' + str(i) + ' has features extracted'

features['allFeatures']=temp

sio.savemat(directory + vidName +'Features',features)

print vidName + ' is done extracting features'
