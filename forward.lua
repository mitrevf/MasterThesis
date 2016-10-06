require 'torch'
require 'nn'

require '../core/autoencoder.lua'
require '../io/lmdb_reader'
require 'image'
imagenet_reader = lmdb_reader('/home/filip/caffe/examples/imagenet/trainlmdb')

ae = autoencoder()

ae:initialize()

ae:load('autoencoder_16.bin')

for i=1,9 do
ae.net:remove(11)
end
data={}
labels={}

counter=1

temp = imagenet_reader:get_data(900)
--for j=1,61  do
  for i=1,900 do
    data['v'..tostring(counter)]=nn.utils.recursiveType(ae:forward(temp[i][1]), 'torch.DoubleTensor')
    labels['l'..tostring(counter)]=temp[i][2]
   counter=counter+1
  end
--end

matt=require 'matio'
mydata={}
mydata['vals']=data
mydata['labs']=labels
matt.save('mydata2.mat', mydata)
