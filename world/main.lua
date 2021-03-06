windowSize = { x= 1024, y = 768 }
worldSize = { x = 1024, y = 1024}
world = {}
world_bitmasks = {}

function createWorld()

	for x = 0, worldSize.x do
		world[x] = {}
		for y = 0, worldSize.y do
			world[x][y] = 0
		end
	end

	values = {}

	for x = 0, worldSize.x do 
		world[x] = {} 
		for y = 0, worldSize.y do 
			world[x][y] = 0 
		end 
	end

	for i = 2, 7 do
		values = createNoise(1024, math.pow(2, i), math.pow(2, 9-i))
		for x = 0, worldSize.x do 
			for y = 0, worldSize.y do 
				world[x][y] = world[x][y] + values[x][y]
			end
		end
	end

	-- nu de waardes normaliseren

	min = 999;
	max = 0;
	for x = 0, table.getn(world) do 
		for y = 0, table.getn(world[x]) do 
			if world[x][y] > max then max = world[x][y] end
			if world[x][y] < min then min = world[x][y] end
		end
	end

	for x = 0, table.getn(world) do 
		for y = 0, table.getn(world[x]) do 
			world[x][y] = (world[x][y] - min) / (max - min) 
		end
	end
			
	-- bitmasks genereren
	
	for x = 0, table.getn(world) do 
		world_bitmasks[x] = {}
		for y = 0, table.getn(world[x]) do 
			mask = 0
			terrainType = getTerrainType(world[x][y])
			if getTerrainType(world[x - 1 >= 0 and x - 1 or 0][y]) == terrainType then mask = mask + 8 end
			if getTerrainType(world[x + 1 <= table.getn(world) and x + 1 or table.getn(world)][y]) == terrainType then mask = mask + 2 end
			if getTerrainType(world[x][(y - 1) >= 0 and y - 1 or 0]) == terrainType then mask = mask + 1 end
			if getTerrainType(world[x][(y + 1) <= table.getn(world[x]) and y + 1 or table.getn(world[x])]) == terrainType then mask = mask + 4 end
		
			world_bitmasks[x][y] = mask 
		
		end
	end

	for i = 0, 1 do 
		createRiver()
	end



end

function getTerrainType(value) 

	if value < 0.2 then return 0
	elseif value < 0.4 then return 1
	elseif value < 0.5 then return 2
	elseif value < 0.7 then return 3
	elseif value < 0.9 then return 4
	else return 5
	end
end

function interpolate(y1, y2, x)
	-- smoothstep interpolation
	return y1 + (y2 - y1) * (3 * math.pow(x, 2) - 2 * math.pow(x, 3))
end

function createNoise(length, frequency, amplitude) 
	points = {}

	values = {}

	for x = 0, frequency + 1 do
		points[x] = {}
		for y = 0, frequency + 1 do
			points[x][y] = math.random()
		end
	end

	local width = length / frequency

	for x = 0, length do
		values[x] = {}
		for y = 0, length do
			i = math.floor(x / length * frequency)
			j = math.floor(y / length * frequency)
			x1 = interpolate(points[i][j], points[i + 1][j], (x - i * width) / width)
			x2 = interpolate(points[i][j + 1], points[i + 1][j + 1], (x - i * width) / width)
			values[x][y] = interpolate(x1, x2, (y - j * width) / width) * amplitude
		end
	end
		
	return values
end

function findNeighbors(x, y)
	neighbors = {}

	if x >=1 then
		table.insert(neighbors, {x = x - 1, y = y, direction = 'west'}) end
	if x <= worldSize.x -1 then
		table.insert(neighbors, {x = x + 1, y = y, direction = 'east'}) end
	if y >= 1 then
		table.insert(neighbors, {x = x, y = y - 1, direction = 'north'}) end
	if y <= worldSize.y - 1 then
		table.insert(neighbors, {x = x, y = y + 1, direction = 'south'}) end

	return neighbors

end

function createRiver() 

	local done = false
	local stuck = false
	local length = 0
	local river = {}
	local water_reached = false
	local direction = "north"
	local lowest_neighbor
	local neighbors
	local failed = false
	local done = false
	

	while done == false do

		x = math.floor(math.random() * 1024)
		y = math.floor(math.random() * 768)
		
		--print('Coordz: ' .. x .."," .. y)

		length = 0
		turns = 0
		river = {}
		water_reached = false
		lowest_direct = nil
		failed = false

		while water_reached == false and failed == false do

			neighbors = findNeighbors(x, y)
			min_height = world[x][y] 
			lowest_direction = direction

			for _, n in ipairs(neighbors) do
				if world[n.x][n.y] < min_height then
					min_height = world[n.x][n.y]
					lowest_direction = n.direction
				end
			end


			if lowest_direction == 'west' then lowest_neighbor = neighbors[1];  end
			if lowest_direction == 'east' then lowest_neighbor = neighbors[2];  end
			if lowest_direction == 'north' then lowest_neighbor = neighbors[3]; end
			if lowest_direction == 'south' then lowest_neighbor = neighbors[4]; end


			if lowest_neighbor == nil then failed = true  


			else 
				if direction ~= lowest_direction then
					--print(x .. ", " .. y .. "(" .. direction .. ")" .. "->" .. lowest_neighbor.x .. ", " ..lowest_neighbor.y .. " = " .. lowest_direction)
					turns = turns + 1 
					direction = lowest_direction
				end

				x = lowest_neighbor.x
				y = lowest_neighbor.y
			end	
			length = length + 1

			--print(x .. "," .. y)

			table.insert(river, {x = x, y =y})

			if world[x][y] <= 0.4 then 
				water_reached = true 
			end

			if length > 500 then 
				failed = true 
			end

		end

		if length >= 99 and water_reached == true and turns < 10 then 
			done = true 
			print("rivier met " .. turns .. " bochtjes, lengte: " .. length)
		end

	end

	for i, p in ipairs(river) do
		
		if i < table.getn(river) / 2 then 
			for x = -1, 1 do
				for y = -1, 1 do 
					world[p.x + x][p.y + y] = 2
				end
			end
		else 
			for x = -2, 2 do
				for y = -2, 2 do 
					world[p.x + x][p.y + y] = 2
				end
			end
		end
	end

end

noise = {}

function love.load()

	math.randomseed(os.time())
	createWorld()

end



function love.draw()
	drawWorld()
end

function drawWorld() 

	love.graphics.setColor(1, 1, 1)
	for x = 0, windowSize.x do
		for y = 0, windowSize.y do
			if world[x][y] < 0.2 then
				love.graphics.setColor(0, 0, 0.5)
			elseif world[x][y] < 0.4 then
				love.graphics.setColor(25/256, 25/256, 0.5)
			elseif world[x][y] < 0.5 then
				love.graphics.setColor(240/256, 240/256, 64/256)
			elseif world[x][y] < 0.7 then
				love.graphics.setColor(50/256, 220/256, 20/256)
			elseif world[x][y] < 0.8 then
				love.graphics.setColor(16/256, 160/256, 0)
			elseif world[x][y] < 0.9 then
				love.graphics.setColor(128/256, 128/256, 128/256)
			elseif world[x][y] <= 1 then
				love.graphics.setColor(1, 1, 1)
			elseif world[x][y] == 2 then
				love.graphics.setColor(0.780, 0.917, 1)
			end

			if world_bitmasks[x][y]  < 15 then love.graphics.setColor(0, 0, 0) end
			
			love.graphics.points(x, y);
		end
	end
end

function love.keypressed(key)
	if key == 'n' then 
		createWorld()
	elseif key == 'q' then 
		love.event.quit()
	end
end
