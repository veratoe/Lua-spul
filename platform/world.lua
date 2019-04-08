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
	local has_gap 
	local y_delta = 0

	for x = 0, World.dimensions.x do
		World.grid[x] = {}
		World.boxes[x] = {}

		has_gap = false

		for y = 0, World.dimensions.y do
			if y == 29 + y_delta then 
				if gap <= 0  then World.grid[x][y] = 1  end
				print(has_gap, gap, x, World.grid[x > 2 and x-2 or x][y])
			end
			World.boxes[x][y] = Box.getBoundingBox(x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size) 
		end


		gap = gap -1

		if gap <= 0 and x > 10 and World.grid[x - 1 > 0 and x - 1 or x][ 29 + y_delta] == 1 then 
			gap = math.random() * 40 > 35 and math.floor(math.random() * 4) + 2 or 0
			if gap > 0 then 
				y_delta = math.random() * 30 > 25 and math.floor( math.random() * 6  - 3) or y_delta
			end
		end

	end
end

function World.update() 

end

function World.draw()

	love.graphics.setCanvas(World.canvas)
	love.graphics.clear()

	love.graphics.setColor(1, 1, 1)

	local startX = math.floor((Camera.x - 400)/ World.tile_size)
	local stopX = startX + math.floor(800 / World.tile_size)
	local startY = math.floor((Camera.y -300 )/ World.tile_size)
	local stopY = math.floor((Camera.y + 600 )/ World.tile_size)

	for x = startX, stopX do
		for y = startY, stopY do
			if World.grid[x][y] == 1 and x >= 1 and World.grid[x - 1][y] ~= 1 then
				love.graphics.draw(vloer, tile_sprites[0], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
			elseif World.grid[x][y] == 1 and  x <= World.dimensions.x - 1 and World.grid[x + 1][y] ~= 1 then
				love.graphics.draw(vloer, tile_sprites[5], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
			elseif World.grid[x][y] == 1 then
				vloer_index = math.mod(x, 4) + 1
				love.graphics.draw(vloer, tile_sprites[vloer_index], x * World.tile_size, y * World.tile_size -15, 0, 0.25, 0.5)
			end
		end
	end
	
	PlayerDust.draw()

	--boxes, edges = World.findCollidingBoxes(Player.box)

	--love.graphics.setColor(0, 1, 0)
	--for _, box in ipairs(boxes) do 
	--	local rectangle = Box.toRectangle(box)
	--	--love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
	--end

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
