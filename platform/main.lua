Utils = require "utils"
Box = require "box"
Game = require "game"
Player = require "player"
Camera = require "camera"
Controls = require "controls"
World = require "world"

math.randomseed(os.time())

function love.load()
	World.create()
	Player.load()

end

function love.draw()
	Camera:apply()

	World.draw()
	Camera:reset()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(World.canvas)

	Camera:apply()
	Player.draw()
	Camera:reset()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Player.canvas)


	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.getState()), 10, 25)
	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.x .. ":" .. Player.y), 10, 25)
	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.x .. ":" .. Camera.x), 10, 25)
	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), 
	--	Player.x - Camera.x .. " <> " .. Player.y - Camera.y ), 10, 40)
	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.vx .. ":" .. Player.vy), 10, 40)
	love.graphics.rectangle("line", 350, 250, 100, 100)
end

function love.update()
	Player.update()
	Controls.update()
end
