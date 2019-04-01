World = {}

World.grid = {}
World.boxes = {}
World.dimensions = { x = 50, y = 20 }
World.tile_size = 20

function World.create()

	for x = 0, World.dimensions.x do
		World.grid[x] = {}
		World.boxes[x] = {}
		for y = 0, World.dimensions.y do
			if y > 10 then
				World.grid[x][y] = math.random() * 40 > 35 and 1 or 0
			end
			if y == 20 then World.grid[x][y] = 1 end
			World.boxes[x][y] = Box.getBoundingBox(x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size) 
		end
	end
end

function World.update() 

end

function World.draw()

	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if World.grid[x][y] == 1 then
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
			end
		end
	end

	World.findCollidingBoxes(Player.box)

	love.graphics.draw(World.collisions)
end

World.canvas = love.graphics.newCanvas(800, 600)
World.collisions = love.graphics.newCanvas(800, 600)

function World.findCollidingBoxes(box, edge)
	
	collidesLeft = false
	collidesRight = false
	collidesTop = false
	collidesBottom = false
	
	love.graphics.setCanvas(World.collisions)
	love.graphics.clear()
	boxes = {}
	edges = { left= false, right= false, top= false, bottom= false }

	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if Box.collides(World.boxes[x][y], box) and World.grid[x][y] == 1 then
				edges = Box.collidingEdge(World.boxes[x][y], box)
				love.graphics.setColor(0, 1, 0)
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
				if edge == nil or (edge == "left" and edges.left) or (edge == "right" and edges.right) or (edge =="top" and edges.top) or (edge == "bottom" and edges.bottom) then
					table.insert(boxes, World.boxes[x][y])
				end
			end
		end
	end

	love.graphics.setCanvas()

	return boxes, edges
end


return World
