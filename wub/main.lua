local map = require("map")

local camera = {
	x = 0,
	y = 0
}

function love.load()
	x, y, w, h = 20, 20, 60, 60
	t = 0
	love.graphics.setBackgroundColor(1,1,1)
	love.graphics.setPointSize(2)

	map.load()
	map.draw()
end

function love.update(dt)
	t = t + dt
	w = w + 3 * math.sin(t)
	h = h + 3 * math.cos(t)

	if love.keyboard.isDown('s') then 
		camera.y = camera.y - 5 
	elseif love.keyboard.isDown('w') then 
		camera.y = camera.y + 5 
	elseif love.keyboard.isDown('a') then 
		camera.x = camera.x + 5 
	elseif love.keyboard.isDown('d') then 
		camera.x = camera.x - 5 
	end
end

function love.draw()
	love.graphics.draw(map.canvas, camera.x, camera.y, 0, map.zoom, map.zoom)
end

function love.keypressed(key)

	if key == 'q' then 
		love.window.close()
		love.event.quit()
	end
end

function love.wheelmoved(x, y)
	if y > 0 then
		map.zoom = map.zoom + 0.05 
	elseif y < 0 then
		map.zoom = map.zoom - 0.05 
	end
end
