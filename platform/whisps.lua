Whisps = {
	canvas = love.graphics.newCanvas(800, 600)
}

local shader = love.graphics.newShader("fade.glsl")
local blur = love.graphics.newShader("blur.glsl")

local image = love.graphics.newImage("assets/poppetje.png")
local buffer = love.graphics.newCanvas(800, 600)
local x, y

local whisp

function Whisps.create()
	
	local whisp = {
		x = 900,
		y = (math.random() * 2 - 1) * 200 + 300,
		vx = - math.random() * 2.0 - 2.0,
		vy = math.random() ,
		time = 0
	}


	return whisp
end

function Whisps.load()

	whisp = Whisps.create()
end

function Whisps.update(dt)
		
	whisp.time = whisp.time + dt
	whisp.x = whisp.x + whisp.vx
	whisp.y = whisp.y + math.sin(whisp.time / 10.0) * whisp.vy
	

end

function Whisps.draw()

	love.graphics.setCanvas(buffer)
	love.graphics.clear()
	love.graphics.setShader(shader)
	--blur:send("direction", {1.0, 0.0})
	love.graphics.draw(Whisps.canvas)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setShader()
	love.graphics.setCanvas(Whisps.canvas)
	love.graphics.clear()
	love.graphics.draw(buffer)

	--love.graphics.setBlendMode("lighten", "premultiplied")
	love.graphics.draw(image, whisp.x, whisp.y, 0, 0.5)
	
	--love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()
	

end




return Whisps
