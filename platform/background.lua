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
			x = math.random() * 800,
			y = math.random() * 300,
			vx = math.random() * 2,
			scale = 0.3 + math.random() * 0.7,
			--opacity = 0.8 + math.random() * 0.2
			opacity = 1.0 --0.8 + math.random() * 0.2
		}
	end
	
end

function Background.update()

	for _, cloud in ipairs(Background.clouds) do
		cloud.x = cloud.x - cloud.vx
		if cloud.x < -400 * cloud.scale then 
			cloud.x = 840;
			cloud.y = math.random() * 300
			cloud.vx = math.random() * 2 
		end
	end

end

function Background.draw()

	love.graphics.setCanvas(Background.canvas)
	love.graphics.setColor(123/255, 227/255, 252/255, 1.0)
	love.graphics.rectangle("fill", 0, 0, 800, 600)

	love.graphics.setBlendMode("lighten", "premultiplied")
	for _, cloud in ipairs(Background.clouds) do
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(cloudImage, cloud.x, cloud.y, 0, cloud.scale)
	end

	love.graphics.setBlendMode("alpha", "alphamultiply")

	love.graphics.setCanvas()

end

return Background
