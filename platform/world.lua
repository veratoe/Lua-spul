World = {}

World.grid = {}
World.dimensions = { x = 50, y = 20 }
World.tile_size = 20

function World.create()

	for x = 0, World.dimensions.x do
		World.grid[x] = {}
		for y = 10, World.dimensions.y do
			World.grid[x][y] = math.random() * 40 > 35 and 1 or 0
		end
	end
end

function World.draw()

	print("drawan")
	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if World.grid[x][y] == 1 then
				print(x .. ":" .. y)
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
			end
		end
	end

end

World.canvas = love.graphics.newCanvas(800, 600)

function World.getTile(x, y)
	love.graphics.setCanvas(World.canvas)
	love.graphics.setColor(0, 0, 1)
	love.graphics.circle("line", x, y, 4)
	x = math.ceil(x / World.tile_size)
	y = math.ceil(y / World.tile_size)

	love.graphics.setCanvas()
	return World.grid[x][y]
end


return World
