Background = {
	canvas = love.graphics.newCanvas(800, 600),
	clouds = {}
}


local num_clouds = 10 
local cloudImage

function Background.load() 
	cloudImage = love.graphics.newImage("assets/wolk.png")

	for i = 0, num_clouds do 
		Background.clouds[i] = {
			x = 840,
			y = math.random() * 300,
			vx = math.random() * 2,
			scale = math.ceil(math.random() * 2)
		}
	end
	
end

function Background.update()

	for _, cloud in ipairs(Background.clouds) do
		cloud.x = cloud.x - cloud.vx
		if cloud.x < -200 then 
			cloud.x = 840;
			cloud.y = math.random() * 300
			cloud.vx = math.random() * 2 
		end
	end

end

function Background.draw()

	love.graphics.setCanvas(Background.canvas)
	love.graphics.setColor(123/255, 227/255, 252/255)
	love.graphics.rectangle("fill", 0, 0, 800, 600)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setBlendMode("lighten", "premultiplied")
	for _, cloud in ipairs(Background.clouds) do
		love.graphics.draw(cloudImage, cloud.x, cloud.y, 0, 0.5, 0.5)
	end
	love.graphics.setBlendMode("alpha")

	love.graphics.setCanvas()

end

return Background
