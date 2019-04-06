local states = { idle = 0, in_air = 1, running = 2, jump = 3 }
local edges
local boxes

Player = {
	direction = 1, 		-- 1 naar rechts, -1 naar links
	x = 100,
	y = 200,
	vx = 0,
	vy = 0,

	max_speed = 2,
	acc_x = 3,

	box,

	state = 0,

	canvas = love.graphics.newCanvas(800, 600)
}


function canReachState(state)
	if (state == states.in_air) then
		for _, allowed_state in pairs({ states.idle, states.running, states.jump }) do 
			if Player.state == allowed_state then return true end
		end
		return false
	elseif (state == states.running) then
		for _, allowed_state in pairs({ states.idle }) do 
			if Player.state == allowed_state then return true end
		end
		return false
		
	elseif (state == states.idle) then
		for _, allowed_state in pairs({ states.in_air, states.running }) do 
			if Player.state == allowed_state then return true end
		end
		return false
		
	elseif (state == states.jump) then
		for _, allowed_state in pairs({ states.idle, states.running }) do 
			if Player.state == allowed_state then return true end
		end
		return false
	end

	print("DIT MAGE JE NIET ZIEN!!")

end

function Player.setState(state)
	if canReachState(state) then
		onLeaveState(Player.state, state)
		Player.state = state
		onEnterState(state)
	end
end

-- return string text for current state
function Player.getState()
	for i, s in pairs(states) do if s == Player.state then return i end end
end

local image_idle
local image_in_air
local images_running = {}

function Player.resetBoundingBox()
	local x, y = image_idle:getDimensions() 
	Player.box = Box.getBoundingBox(Player.x, Player.y, x * 0.5, y * 0.5) 
end

function Player.load() 

	image_idle = love.graphics.newImage("assets/poppetje.png")
	print(image_idle:getDimensions())
	Player.resetBoundingBox()

	for i = 0, 3 do
		images_running[i] = love.graphics.newImage("assets/poppetje_rennen" .. i .. ".png")
	end

	image_in_air = love.graphics.newImage("assets/poppetje_in_air.png")
end

function Player.update() 

	boxes, edges = World.findCollidingBoxes(Player.box)

	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), edges.left and 1 or 0 .. ":" .. Player.y), 10, 55)

	if edges.top then 
		if (Player.vy > 0) then
			Player.box = Box.snap(World.findCollidingBoxes(Player.box, "top")[1], Player.box, "top")
			Player.x = Player.box.x1
			Player.y = Player.box.y1
			Player.vy = 0
			Player.setState(states.idle)
		end
	else
		Player.setState(states.in_air)
		Player.vy = Player.vy + 0.5
	end

	if edges.bottom then 
		if Player.vy < 0 then Player.vy = Player.vy * -1 end
	end


	if love.keyboard.isDown("d") then
		Player.setState(states.running)
		Player.direction = 1
		if (Player.vx < Player.max_speed) then Player.vx = Player.vx + Player.acc_x  end
	end

	if love.keyboard.isDown("a") then
		Player.setState(states.running)
		Player.direction = -1
		if (Player.vx > -1 * Player.max_speed) then Player.vx = Player.vx - Player.acc_x  end
	end

	if love.keyboard.isDown("space") then 
		Player.setState(states.jump)
	end

	if not love.keyboard.isDown("d") and not love.keyboard.isDown("a") and math.abs(Player.vx) > 0 then 
		if Player.vx < 0 then 
			Player.vx = Player.vx + 0.2
			if Player.vx > 0 then Player.vx = 0 end
		else 
			Player.vx = Player.vx - 0.2
			if Player.vx < 0 then Player.vx = 0 end
		end
	end

	-- opnieuw kijken of er nog colliding boxes zijn; mogelijk niet meer door correctie in verticale richting
	boxes, edges = World.findCollidingBoxes(Player.box)

	if edges.left and Player.vx > 0 then 
		Player.vx = 0 
		Player.box = Box.snap(World.findCollidingBoxes(Player.box, "left")[1], Player.box, "left")
		Player.x = Player.box.x1
		Player.y = Player.box.y1
	end
	if edges.right and Player.vx < 0 then 
		Player.vx = 0 
		Player.box = Box.snap(World.findCollidingBoxes(Player.box, "right")[1], Player.box, "right")
		Player.x = Player.box.x1
		Player.y = Player.box.y1
	end

	Player.x = Player.x + Player.vx
	Player.y = Player.y + Player.vy

	Player.resetBoundingBox()

	-- update camera
	local cameraOffsetX = Player.x - Camera.x
	local cameraOffsetY = Player.y - Camera.y

	if cameraOffsetX > 20 then
		Camera:move(Utils.lerp(0, cameraOffsetX, 0.1), 0)
	end

	if cameraOffsetX < -20 then
		Camera:move(Utils.lerp(0, cameraOffsetX, 0.1), 0)
	end

	if cameraOffsetY < -50 then
		Camera:move(0, Utils.lerp(0, cameraOffsetY, 0.1))
	end

	if cameraOffsetY > 50 then
		Camera:move(0, Utils.lerp(0, cameraOffsetY, 0.1))
	end


	Player.whileInState(Player.state)
end

function Player.draw()

	love.graphics.setCanvas(Player.canvas)
	love.graphics.clear()

	rectangle = Box.toRectangle(Player.box)
	--if Player.direction == directions.left then love.graphics.setColor(.75, .95, .89) else love.graphics.setColor(.75, .25, .49) end
	--love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h)

	if Player.state == states.running then 
		local int, fract = math.modf(love.timer.getTime())
		local index = math.mod(math.floor(fract * 10), 4)
		love.graphics.draw(images_running[index], Player.x, Player.y, 0, 0.5 * Player.direction, 0.5, Player.direction == -1 and image_idle:getDimensions() or 0, 0)

	elseif Player.state == states.in_air then 
		love.graphics.draw(image_in_air, Player.x, Player.y, 0, 0.5 * Player.direction, 0.5, Player.direction == -1 and image_idle:getDimensions() or 0, 0)

	elseif Player.state == states.idle then
		love.graphics.draw(image_idle, Player.x, Player.y, 0, 0.5 * Player.direction, 0.5, Player.direction == -1 and image_idle:getDimensions() or 0, 0)
	end
	

	-- local boxes, edges = World.findCollidingBoxes(Player.box)
	--love.graphics.setColor(.75, .95, 89)
	--love.graphics.draw(love.graphics.newText(love.graphics.getFont(), 
	--	"left: " .. (edges.left and 1 or 0) .. ":" ..  "right: " .. (edges.right and 1 or 0) .. ":" .. "top: " .. (edges.top and 1 or 0) .. ":" ..  "bottom: " .. (edges.bottom and 1 or 0) .. ":" ), 10, 55)

	love.graphics.setCanvas()
end

function Player.whileInState(state)

	-- .....

	if state == states.running then
		if Player.vx == 0 then Player.setState(states.idle) end
	end
end

function onLeaveState(oldState, newState)

	-- .....
end

function onEnterState(state)
	
	if state == states.idle then

		-- ...

	elseif state == states.jump then
		Player.vy = - 10
		Player.setState(states.in_air)
	end

end

Player.directions = { left =  0, right =  1}

Player.directions = directions

return Player

