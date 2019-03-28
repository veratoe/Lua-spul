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

function World.draw()

	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if World.grid[x][y] == 1 then
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
			end
		end
	end

--[[
	love.graphics.setColor(1, .5, .5)
	for _, box in ipairs(World.findCollidingBoxes(Player.box)) do
		rectangle = Box.toRectangle(box)	
		love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
	end
]]
	World.findCollidingBoxes(Player.box)

	love.graphics.draw(World.collisions)
end

World.canvas = love.graphics.newCanvas(800, 600)
World.collisions = love.graphics.newCanvas(800, 600)

-- even bruut fors
local collidesLeft
local collidesRight
local collidesTop
local collidesBottom

function World.collidesLeft(box)
	return collidesLeft
end

function World.collidesRight(box)
	return collidesRight
end


function World.collidesTop(box)
	return collidesTop
end

function World.collidesBottom(box)
	return collidesBottom
end

function World.findCollidingBoxes(box)
	
	collidesLeft = false
	collidesRight = false
	collidesTop = false
	collidesBottom = false
	
	love.graphics.setCanvas(World.collisions)
	love.graphics.clear()
	boxes = {}
	for x = 0, World.dimensions.x do
		for y = 0, World.dimensions.y do
			if Box.collides(World.boxes[x][y], box) and World.grid[x][y] == 1 then
				edges = Box.collidingEdge(World.boxes[x][y], box)
				if edges.left then collidesLeft = true end
				if edges.right then collidesRight = true end
				if edges.top then collidesTop = true end
				if edges.bottom then collidesBottom = true end
				--print("left: " .. (edges.left and 1 or 0) .. " right: " .. (edges.right and 1 or 0 ).. " top: " .. (edges.top and 1 or 0) .. " bottom: " .. (edges.bottom and 1 or 0))
				love.graphics.setColor(0, 1, 0)
				love.graphics.rectangle("fill", x * World.tile_size, y * World.tile_size, World.tile_size, World.tile_size)
				table.insert(boxes, World.boxes[x][y])
			end
		end
	end

	love.graphics.setCanvas()

	--print("Left: " .. (collidesLeft and 1 or 0) .. ", right: " .. (collidesRight and 1 or 0))
	return boxes
end


return World
