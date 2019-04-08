Utils = require "utils"
Box = require "box"
Game = require "game"
Player = require "player"
Camera = require "camera"
Controls = require "controls"
World = require "world"
Background = require "background"
PlayerDust = require "playerdust"
Whisps = require "whisps"

math.randomseed(os.time())

function love.load()
	Background.load()
	World.load()
	World.create()
	Player.load()
Whisps.load()

end

function love.draw()

	-- background
	Background.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Background.canvas)

	Whisps.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Whisps.canvas)

	-- poppetje
	Camera:apply()
	Player.draw()
	Camera:reset()

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Player.canvas)

	-- wereld

	Camera:apply()
	World.draw()
	Camera:reset()

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(World.canvas)

	-- overig spul

	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(love.graphics.newText(love.graphics.getFont(), Player.getState()), 10, 25)
	love.graphics.rectangle("line", 350, 250, 100, 100)
end

function love.update(dt)
	Player.update(dt)
	Background.update(dt)
	Whisps.update(dt)
	Controls.update(dt)
end
