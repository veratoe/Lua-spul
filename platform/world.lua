World = {}

World.grid = {}
World.boxes = {}
World.dimensions = { x = 150, y = 50 }
World.tile_size = 50
World.canvas = love.graphics.newCanvas(800, 600)

function World.create()

	for x = 0, World.dimensions.x do
		World.grid[x] = {}
		World.boxes[x] = {}
		for y = 0, World.dimensions.y do
			if y > 10 then
				World.grid[x][y] = math.random() * 180 > 175 and 1 or 0
			end
			if y > 48 then World.grid[x][y] = 1 end
			World.boxes[x][y] = Box.getBoundingBox(x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size) 
		end
	end
end

function World.update() 

end

function World.draw()

	love.graphics.setCanvas(World.canvas)
	love.graphics.clear()
	love.graphics.setColor(208/255, 237/255, 253/255)
	love.graphics.rectangle("fill", 0, 0, 8000, 6000)

	love.graphics.setColor(1, 1, 1)

	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if World.grid[x][y] == 1 then
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
			end
		end
	end

	boxes, edges = World.findCollidingBoxes(Player.box)

	love.graphics.setColor(0, 1, 0)
	for _, box in ipairs(boxes) do 
		local rectangle = Box.toRectangle(box)
		love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
	end

	love.graphics.setCanvas()

end


function World.findCollidingBoxes(box, edge)
	
	boxes = {}
	collidingEdges = { left= false, right= false, top= false, bottom= false }

	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if Box.collides(World.boxes[x][y], box) and World.grid[x][y] == 1 then
				edges = Box.collidingEdge(World.boxes[x][y], box)
				if edges.left then collidingEdges.left = true end
				if edges.right then collidingEdges.right = true end
				if edges.top then collidingEdges.top = true end
				if edges.bottom then collidingEdges.bottom = true end
				if edge == nil or (edge == "left" and edges.left) or (edge == "right" and edges.right) or (edge =="top" and edges.top) or (edge == "bottom" and edges.bottom) then
					table.insert(boxes, World.boxes[x][y])
				end
			end
		end
	end

	return boxes, collidingEdges
end


return World
