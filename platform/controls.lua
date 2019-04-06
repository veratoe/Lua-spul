Controls = {}


function Controls.update()

	if love.keyboard.isDown("d") then
		--Player.moveRight()
	end	

	if love.keyboard.isDown("a") then
		--Player.moveLeft()
	end	

	if love.keyboard.isDown("d")  == false and love.keyboard.isDown("a")  == false then 
		--Player.stop()
	end

	if love.keyboard.isDown("space") then
		--Player.jump()
	end	
end

function love.keypressed(key) 

	if key == "q" then
		love.event.quit()
	end
end

function love.wheelmoved(x,y)
	Camera:zoom(y)
end

return Controls
