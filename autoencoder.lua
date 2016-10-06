require 'torch'
require 'cutorch'
require 'cudnn'
require 'nn'
require 'cunn'

autoencoder = {}
autoencoder.__index = autoencoder

setmetatable(autoencoder, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function autoencoder.new()
  local self = setmetatable({}, autoencoder)
  return self
end

function autoencoder:initialize()
  local pool_layer1 = nn.SpatialMaxPooling(2, 2, 2, 2)
  local pool_layer2 = nn.SpatialMaxPooling(2, 2, 2, 2)
  self.net = nn.Sequential()
  self.net:add(nn.SpatialConvolution(3, 8, 3, 3, 1, 1, 1, 1))
  self.net:add(nn.ReLU())
  self.net:add(nn.SpatialConvolution(8, 12, 3, 3, 1, 1, 1, 1))
  self.net:add(nn.ReLU())
  self.net:add(pool_layer1)
  self.net:add(nn.SpatialConvolution(12, 16, 3, 3, 1, 1, 1, 1))
  self.net:add(nn.ReLU())
  --self.net:add(pool_layer2)
  self.net:add(nn.Reshape(16 * 8 * 8))
  self.net:add(nn.Linear(16 * 8 * 8, 128))
  self.net:add(nn.Linear(128, 16 * 8 * 8))
  self.net:add(nn.Reshape(16, 8, 8))
  self.net:add(nn.SpatialConvolution(16, 12, 3, 3, 1, 1, 1, 1))
  self.net:add(nn.ReLU())
  self.net:add(nn.SpatialMaxUnpooling(pool_layer1))
  self.net:add(nn.SpatialConvolution(12, 8, 3, 3, 1, 1, 1, 1))
  self.net:add(nn.ReLU())  
  self.net:add(nn.SpatialConvolution(8, 3, 3, 3, 1, 1, 1, 1))
  self.net = self.net:cuda()

end

function autoencoder:printself()
  print(self.net)
end

function autoencoder:save(filename)
  torch.save(filename, self.net)
end

function autoencoder:load(filename)
  self:initialize()
  self.net = torch.load(filename)
end

function autoencoder:forward(input)
  return self.net:forward(input)
end
