Animation = {}

function Animation:new(spriteSheet, width, height, duration)

	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.spriteSheet = spriteSheet
	self.currentFrame = 0

	imageWidth, _ = spriteSheet:getDimensions()
	self.frames = imageWidth  / width
	self.frame_duration = duration / self.frames
	self.time = 0

	self.quads = {}

	for i = 0, self.frames do
		self.quads[i] = love.graphics.newQuad(i * width, 0, width, height, spriteSheet:getDimensions())
	end

	Hooks.bind("love_update", function (...) self:update(...) end)

	return o

end

function Animation:update(dt, wub) 

	self.time = self.time + dt
	if self.time >= self.frame_duration then 
		self.time = self.time - self.frame_duration
		self.currentFrame = self.currentFrame + 1;
	end

	if self.currentFrame > self.frames - 1 then 
		self.currentFrame = 0
	end

end

function Animation:getFrame()
	return self.quads[self.currentFrame]

end

function Animation:draw(x, y)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.spriteSheet, self:getFrame(), x, y)
end


return Animation
