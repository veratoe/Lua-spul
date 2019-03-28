local moonshine = require 'moonshine'

function love.load()

	math.randomseed(os.time())
	
	myShader = love.graphics.newShader[[
		extern vec2 position;
		extern float radius;
		extern vec2 direction;

		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {

			vec2 wub = texture_coords - position;
			float d = pow(dot(wub, wub), 0.5);
			if (d > radius)
				return vec4(0, 1, 0, 1);
			else
				return vec4(1.0, 0, 0, 1.0);

		}
	]]

	local r = 100

	for i = 1, 100 do
		local blob = {}
		blob._x = (math.random() * 2 - 1)* r + 400
		blob._y = (math.random() * 2 - 1)* r + 300
		blob.vx = - 0.8 * (my - blob._y)
		blob.vy = 0.8 * (mx - blob._x)
		blob.r = math.random() * r  * 0.10  + 4
		a = math.random() * 0.2 + 0.6
		blob.color = { a * 0.879, a * 0.07, a * 0.114 }
		table.insert(blobs, blob)

	end

	image = love.graphics.newImage("wub.png")

	effect = moonshine(moonshine.effects.glow)
	effect.glow.strength = 40

end

t = 0

mx = 400
my = 300
blobs = {}

function blur_canvas(canvas)

	width, height = canvas:getDimensions()
	local buffer = love.graphics.newCanvas(width, height)
	love.graphics.setShader(myShader)

	love.graphics.setCanvas(buffer)
	myShader:send("direction", { 1.0 / width, 0.0 })
	love.graphics.draw(canvas)

	love.graphics.setCanvas(canvas)
	myShader:send("direction", { 0.0, 1.0 / height })
	love.graphics.draw(buffer)

	love.graphics.setShader()
end

function love.update(dt)

	for i, blob in ipairs(blobs) do 
		f = math.pow(math.pow(blob._x - mx, 2) + math.pow(blob._y - my , 2), 0.5) / 100
		blob.vx =  blob.vx - (blob._x - mx) / f * dt
		blob.vy =  blob.vy - (blob._y - my) / f * dt
		blob._x = blob._x + blob.vx * dt
		blob._y = blob._y + blob.vy * dt
		blob._r = blob.r * (0.1 + 0.45 * (math.sin(t/3) + 1))
		blob._color = {}
		for _,c in ipairs(blob.color) do
			table.insert(blob._color, c  + blob._r / blob.r)
		end
	end
end

function love.draw()

	c = love.graphics.newCanvas(800, 600)

	love.graphics.setCanvas(c)

	for i, blob in ipairs(blobs) do
		love.graphics.setColor(blob._color)
		love.graphics.circle("fill", blob._x, blob._y, blob._r )
	end

	love.graphics.setCanvas()
love.graphics.setColor(1, 1, 1)
	effect(function() 
		love.graphics.draw(c)
	end)

end

function love.keypressed()
	love.event.quit()
end

function love.mousepressed() 
	mx, my = love.mouse.getPosition()
end

