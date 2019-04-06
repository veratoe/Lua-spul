Animation = require("animation")

function love.load()
	animation = Animation:new(love.graphics.newImage("sprites.png"), 100, 200, 0.25)
end

function love.update(dt)
	animation:update(dt)
end

function love.draw()
	animation:draw(love.mouse.getX(), love.mouse.getY())
end
