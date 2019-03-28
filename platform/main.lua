Game = require "game"
Player = require "player"
Controls = require "controls"
World = require "world"
Box = require "box"

math.randomseed(os.time())

function love.load()
	World.create()

end

function love.draw()
	World.draw()
	Player.draw()
	love.graphics.setColor(Player.direction == Player.directions.left and {1, 0, 0} or {0, 1, 0})

	love.graphics.setColor({1, 1, 1})
	love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.getState()), 10, 10)
	love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.x .. ":" .. Player.y), 10, 25)
	love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.vx .. ":" .. Player.vy), 10, 40)

	love.graphics.draw(World.canvas)
end

function love.update()
	Player.update()
	Controls.update()
end
