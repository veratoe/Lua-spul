PlayerDust = {}

local ps
local image

function PlayerDust.create()

	image = love.graphics.newImage("assets/blaadje1.png");
	ps = love.graphics.newParticleSystem(image, 500);
	ps:setParticleLifetime(1, 2)
	ps:setLinearAcceleration(-5, 200, 5, 200)
	ps:setDirection(math.pi, 2 * math.pi)
	ps:setSpeed(100, 180)
	ps:setSizes(0.6, 0.8)
	ps:setSpread(2 * math.pi)
	ps:setSpin(0, 6 * math.pi)
	ps:setColors(1, 1, 1, 1.0, 1, 1, 1, 0)
--[[
	ps:setColors(
		142/255, 110/255, 24/255, 0.8,
		112/255, 82/255, 0/255, 0.1,
		142/255, 110/255, 24/255, 0.0,
		1.0, 0.5, 0.5, 0.0
	)
]]--
	--ps:moveTo(x, y)
	ps:setEmissionRate(15)

end

function PlayerDust.stop()
	ps:stop()
end

function PlayerDust.pause()
	ps:pause()
end

function PlayerDust.start()
	ps:start()
end

function PlayerDust.update(dt, x, y)
	ps:moveTo(x, y)
	ps:update(dt)
end

function PlayerDust.draw()
	--love.graphics.setCanvas()
	--love.graphics.setShader()

	love.graphics.draw(ps)

--love.graphics.setCanvas(copy) --love.graphics.clear()
	--love.graphics.draw(ps)

	---- blur
	--if do_blur then 

	--	-- glow pass
	--	love.graphics.setShader(glow)
	--	love.graphics.setCanvas(back)
	--	love.graphics.clear()
	--	love.graphics.draw(copy)

	--	-- blur pass
	--	love.graphics.setShader(blur)
	--	love.graphics.setCanvas(front)
	--	love.graphics.clear()
	--	blur:send("direction", {1.0, 0.0})
	--	love.graphics.draw(back)

	--	love.graphics.setCanvas(back)
	--	love.graphics.clear()
	--	blur:send("direction", {0.0, 1.0})
	--	love.graphics.draw(front)

	--	--love.graphics.setCanvas(front)
	--	--love.graphics.clear()
	--	love.graphics.setShader()
	--	love.graphics.setBlendMode("add", "premultiplied");
	--	love.graphics.draw(copy)

	--	love.graphics.setBlendMode("alpha", "premultiplied");
	--end
	--
	--love.graphics.setShader()
	--love.graphics.setCanvas()
	--love.graphics.draw(do_blur and back or copy)


end

return PlayerDust
