function love.load()
	love.graphics.setBackgroundColor(0.980, 0.958, 0.958)
	x = 10
	y = 10
	t = 0
	bullets = {}
	for i = 1, 10000 do 
		table.insert(bullets, { 
			x = math.random() * 100, 
			y = math.random() * 100, 
			t = math.random() * 6,
			a = math.random () * 2,
			b = math.random() * 2,
			p = math.random() * 5,
			c = { math.random(), 0 , math.random(), math.random() }

		})
	end
	love.graphics.setColor(2, 3, 1)
end


function love.draw()
	love.graphics.setColor({1, 0, 0})
	a, b = love.graphics.getDimensions()
	love.graphics.print(a .. ": " .. b)
	for i, bullet in ipairs(bullets) do

		love.graphics.setColor(bullet.c)
		love.graphics.circle("fill", bullet.x + 300, bullet.y + 300, 8)
	end
end

function love.update(dt)
	for i, bullet in ipairs(bullets) do
		bullet.t = bullet.t + dt * bullet.p
		bullet.x = bullet.x + bullet.a * math.sin(bullet.t) 
		bullet.y = bullet.y + bullet.b * math.cos(bullet.t) 
	end
end

function love.keypressed( ... )
	love.window.close()
end