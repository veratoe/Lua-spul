local ps

function love.load()
	
	love.window.setMode(800, 600)

	glow = love.graphics.newShader("glow.glsl")
	blur = love.graphics.newShader("blur.glsl")

	image = love.graphics.newImage("circle.png");
	ps = love.graphics.newParticleSystem(image, 5000);
	ps:setParticleLifetime(4,10)
	ps:setLinearAcceleration(0, -20, 0, -50)
	ps:setDirection(math.pi * 1.5)
	ps:setSpeed(20)
	ps:setRadialAcceleration(4, 5)
	ps:setSpread(2 * math.pi)
	ps:setSizeVariation(1)
	ps:setSizes(1.0, 0,1)
	ps:setColors(
		0.0, 0.0, 0.0, 0.0, 
		0.4, 0.4, 1.0, 0.5,
		1.0, 0.5, 0.5, 1.0
	)
	ps:setEmissionRate(500)

	print(love.graphics.getDimensions());
end

function love.update(dt)
	ps:update(dt)
	ps:moveTo(love.mouse.getX(), love.mouse.getY())

end

local copy = love.graphics.newCanvas(800, 600)
local front = love.graphics.newCanvas(800, 600)
local back = love.graphics.newCanvas(800, 600)

function love.draw()
	love.graphics.setShader()

	love.graphics.setCanvas(copy)
	love.graphics.clear()
	love.graphics.draw(ps)

	-- blur
	if do_blur then 

		-- glow pass
		love.graphics.setShader(glow)
		love.graphics.setCanvas(back)
		love.graphics.clear()
		love.graphics.draw(copy)

		-- blur pass
		love.graphics.setShader(blur)
		love.graphics.setCanvas(front)
		love.graphics.clear()
		blur:send("direction", {1.0, 0.0})
		love.graphics.draw(back)

		love.graphics.setCanvas(back)
		love.graphics.clear()
		blur:send("direction", {0.0, 1.0})
		love.graphics.draw(front)

		--love.graphics.setCanvas(front)
		--love.graphics.clear()
		love.graphics.setShader()
		love.graphics.setBlendMode("add", "premultiplied");
		love.graphics.draw(copy)

		love.graphics.setBlendMode("alpha", "premultiplied");
	end
	
	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.draw(do_blur and back or copy)


end

function love.keypressed(key)
	if key == "q" then 
		love.event.quit()
	end

	if key == "e" then
		do_blur = not do_blur
	end
end
