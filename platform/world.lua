World = {}

World.grid = {}
World.boxes = {}
World.dimensions = { x = 1500, y = 30 }
World.tile_size = 50
World.canvas = love.graphics.newCanvas(800, 600)

local tile_sprites = {}

function World.load()

	vloer = love.graphics.newImage("assets/vloer.png")
	
	for i = 0, 6 do 
		tile_sprites[i] = love.graphics.newQuad(206 * i, 0, 206, 206, vloer:getDimensions())
	end
end

function World.create()

	local gap = 0
	local y_delta = 0

	for x = 0, World.dimensions.x do
		World.grid[x] = {}
		World.boxes[x] = {}
		for y = 0, World.dimensions.y do
			--if y > 10 then
			--	World.grid[x][y] = math.random() * 180 > 175 and 1 or 0
			--end
			if y == 29 + y_delta then 
				if (gap <= 0 or x <= 30) then World.grid[x][y] = 1 end
				if x > 2 and World.grid[x - 2][y] ~= 1 then World.grid[x][y] = 1 end
			end
			World.boxes[x][y] = Box.getBoundingBox(x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size) 
		end
		gap = gap -1
		if gap <= 0 then 
			gap = math.random() * 40 > 35 and math.floor(math.random() * 4) + 4 or 0
			if gap > 0 then 
				y_delta = math.random() * 40 > 35 and math.floor( math.random() * 6  - 3) or y_delta
			end
		end

		--y_delta = math.random() * 40 > 35 and math.floor( math.random() * 6  - 3) or y_delta
	end
end

function World.update() 

end

function World.draw()

	love.graphics.setCanvas(World.canvas)
	love.graphics.clear()

	love.graphics.setColor(1, 1, 1)

	local vloer_index = 1

	for x = 1, World.dimensions.x -1 do
		for y = 0, World.dimensions.y do
			if World.grid[x][y] == 1 and World.grid[x - 1][y] ~= 1 then
				love.graphics.draw(vloer, tile_sprites[0], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
				vloer_index = 1
			elseif World.grid[x][y] == 1 and  World.grid[x + 1][y] ~= 1 then
				love.graphics.draw(vloer, tile_sprites[5], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
				vloer_index = 1
			elseif World.grid[x][y] == 1 then
				love.graphics.draw(vloer, tile_sprites[vloer_index], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
				vloer_index = vloer_index + 1
				if vloer_index > 4 then vloer_index = 1 end
			end
		end
	end

	boxes, edges = World.findCollidingBoxes(Player.box)

	love.graphics.setColor(0, 1, 0)
	for _, box in ipairs(boxes) do 
		local rectangle = Box.toRectangle(box)
		--love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
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
