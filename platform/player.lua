local directions = { left =  0, right =  1}
local states = { idle = 0, in_air = 1, running = 2, jump = 3 }

function lerp (a, b, t)
	return a + (b-a) * t
end
--local function canReachState(state)
--	if (state == states.in_air) then
--		for _, allowed_state in pairs({ states.idle, states.running, states.jump }) do 
--			if Player.state == allowed_state then return true end
--		end
--		return false
--	elseif (state == states.running) then
--		for _, allowed_state in pairs({ states.idle }) do 
--			if Player.state == allowed_state then return true end
--		end
--		return false
--		
--	elseif (state == states.idle) then
--		for _, allowed_state in pairs({ states.in_air, states.running }) do 
--			if Player.state == allowed_state then return true end
--		end
--		return false
--		
--	elseif (state == states.jump) then
--		for _, allowed_state in pairs({ states.idle, states.running }) do 
--			if Player.state == allowed_state then return true end
--		end
--		return false
--	end
--
--	print("DIT MAGE JE NIET ZIEN!!")
--
--end


Player = {
	direction = directions.right,
	x = 100,
	y = 100,
	vx = 0,
	vy = 0,

	max_speed = 2,
	acc_x = 1,

	is_in_air = false,
	box = Box.getBoundingBox(100, 100, 30, 40)
}

--function Player.setState(state)
--	if canReachState(state) then
--		onLeaveState(Player.state, state)
--		Player.state = state
--		onEnterState(state)
--	end
--end
--
---- return string text for current state
--function Player.getState()
--	for i, s in pairs(states) do if s == Player.state then return i end end
--end

function Player.update() 

	Player.box = Box.getBoundingBox(Player.x, Player.y, 30, 40)

	if World.collidesTop(Player.box) then 
		Player.y = math.floor(Player.y / World.tile_size) * World.tile_size
		if (Player.vy > 0 ) then Player.vy = 0 end
		Player.is_in_air = false
	else
		Player.is_in_air = true
		Player.vy = Player.vy + 0.25
	end

	if World.collidesBottom(Player.box) then 
		if Player.vy < 0 then Player.vy = Player.vy * -1 end
	end


	if love.keyboard.isDown("d") then
		if (Player.vx < Player.max_speed) then Player.vx = Player.vx + Player.acc_x  end
	end

	if love.keyboard.isDown("a") then
		if (Player.vx > -1 * Player.max_speed) then Player.vx = Player.vx - Player.acc_x  end
	end

	if love.keyboard.isDown("space") and not Player.is_in_air then 
		Player.vy = -6
		Player.is_in_air = true
	end

	if not love.keyboard.isDown("d") and not love.keyboard.isDown("a") and math.abs(Player.vx) > 0 then 
		if Player.vx < 0 then 
			Player.vx = Player.vx + 0.01
			if Player.vx > 0 then Player.vx = 0 end
		else 
			Player.vx = Player.vx - 0.01
			if Player.vx < 0 then Player.vx = 0 end
		end
	end

	if World.collidesLeft(Player.box) and Player.vx > 0 then 
		Player.vx = 0 
		box = World.findCollidingBoxes(Player.box, "left")[1]
		Box.snap(World.findCollidingBoxes(Player.box, "left")[1], Player.box)
		Player.x = Player.box.x1
		Player.y = Player.box.y1
	end
	if World.collidesRight(Player.box) and Player.vx < 0 then 
		Player.vx = 0 
		box = World.findCollidingBoxes(Player.box, "right")[1]
		Box.snap(World.findCollidingBoxes(Player.box, "right")[1], Player.box)
		Player.x = Player.box.x1
		Player.y = Player.box.y1
	end

	Player.x = Player.x + Player.vx
	Player.y = Player.y + Player.vy
end

function Player.draw()
	rectangle = Box.toRectangle(Player.box)
	if Player.direction == directions.left then love.graphics.setColor(.75, .95, .89) else love.graphics.setColor(.75, .25, .49) end
	love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
end

--function onExecuteState(state)
--
--	if state == states.idle or state == states.running then
--		if not World.collidesTop(Player.box) then 
--			print("wooops we vallen")
--			Player.y = math.ceil(Player.y / World.tile_size) * World.tile_size
--			Player.setState(states.in_air)
--		end
--	end
--
--	if state == states.idle then
--		
--
--	elseif state == states.in_air then
--		Player.vy = Player.vy + 0.35
--		if World.collidesTop(Player.box) then 
--			Player.y = math.floor(Player.y / World.tile_size) * World.tile_size
--			Player.vy = 0 
--			Player.setState(states.idle)
--		end
--
--		if World.collidesBottom(Player.top) then 
--			print("AUW!");
--			if Player.vy < 0 then Player.vy = Player.vy * -1 end
--		end
--
--	elseif state == states.running then 
--		Player.vx = Player.direction == Player.directions.left and -2 or 2
--		if World.collidesLeft(Player.box) and Player.vx > 0 then Player.vx = 0 end
--		if World.collidesRight(Player.box) and Player.vx < 0 then Player.vx = 0 end
--	end
--end

--function onLeaveState(oldState, newState)

--	if newState == states.idle
--
--	print(oldState, newState)
--	if oldState == states.running and newState == states.idle then 
--		Player.vx = 0
--	end
--end

--function onEnterState(state)
--	
--	if state == states.idle then
--		--Player.vx = 0
--	elseif state == states.jump then
--		Player.vy = - 6
--		Player.setState(states.in_air)
--	end
--
--end

Player.directions = { left =  0, right =  1}

Player.directions = directions

return Player

