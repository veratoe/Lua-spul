Camera = {
	scale = 1,
	x = 400,
	y = 300 
}

function Camera:apply()
	love.graphics.push()
	--love.graphics.scale(self.scale)
	love.graphics.translate(-self.x + 400 , -self.y + 300)
end

function Camera:reset()
	love.graphics.pop()
end

function Camera:move(x, y)
	self.x = self.x + x
	if (self.x < 400) then self.x = 400 end
	self.y = self.y + y
	if (self.y < 300) then self.y = 300 end
end

function Camera:zoom(factor)
	self.scale = self.scale + 0.01 * factor
end


return Camera
