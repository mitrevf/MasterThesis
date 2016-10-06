require 'torch'
require 'nn'

require '../core/autoencoder16.lua'
require '../io/lmdb_reader'

defaults = {
  epochs = 40,
  iters = 45,
  learning_rate = 0.01,
  batch_size = 120,
  save_path = './autoencoder_16.bin' 

}

cmd = torch.CmdLine()
cmd:argument('data_path', 'lmdb database to train on')
cmd:option('save_path', defaults.save_path, 'lmdb database to test on')
cmd:option('-epochs', defaults.epochs, 'number of epochs')
cmd:option('-iters', defaults.iters, 'number of iterations per epochs')
cmd:option('-learning_rate', defaults.learning_rate, 'learning rate')
cmd:option('-batch_size', defaults.batch_size, 'batch size')

options = cmd:parse(arg)

print(options)

imagenet_reader = lmdb_reader(options.data_path)

ae = autoencoder()

ae:initialize()

ae:printself()

criterion = nn.MSECriterion():cuda()

trainer = nn.StochasticGradient(ae.net, criterion)

trainer.learningRate = options.learning_rate
trainer.maxIteration = options.iters


for t=1, options.epochs do
  print('Epoch ' .. t)
  data_set = imagenet_reader:get_training_data(options.batch_size)

  trainer:train(data_set)

end

ae:save(options.save_path)
