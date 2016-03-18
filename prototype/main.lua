require "camera"
require "player"
require "ship"

camFollow = "ship"

function love.load()
	-- don't fuck with the pixel art, man
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	player:load()
	ship:load()
	player:setParent(ship)
	ship.x = 280
	ship.y = -80

	camera:setScale(0.05, 0.05)
end

function love.draw()
	-- World
	camera:set()

	love.graphics.setColor(241, 217, 26, 255)
	love.graphics.circle("fill", 0, 0, 50, 32)
	love.graphics.circle("line", 0, 0, 80, 8)

	love.graphics.setColor(17, 27, 26, 255)
	love.graphics.circle("fill", 280, -80, 40, 4)
	love.graphics.circle("line", 280, -80, 60, 4)

	love.graphics.setColor(0, 194, 204, 255)
	love.graphics.circle("fill", -300, 200, 80, 32)
	love.graphics.arc("line", -300, 200, 120, 0, 3 * math.pi / 2, 32)

	love.graphics.setColor(240, 80, 20, 255)
	love.graphics.rectangle("fill", 100, 100, 80, 50)
	love.graphics.rectangle("line", 90, 90, 100, 70)

	love.graphics.setColor(255, 255, 255, 255)
	ship:draw()
	player:draw()

	camera:unset()

	-- UI
	love.graphics.printf("Controls:\nPlayer: WASD\nShip: Arrow Keys\n\nSwap views with SPACEBAR\nScroll wheel to zoom!\n(-/+ also works)", 4, 4, 200, "left")
	love.graphics.print("Novastruct ap0.001", love.graphics.getWidth(), love.graphics.getHeight(), 0, 1, 1, 140, 18)
end

function love.update(dt)
	player:update(dt)
	ship:update(dt)

	if camFollow == "player" then
		camera.x = player.worldX
		camera.y = player.worldY
		camera.rot = player.parent.rot
	elseif camFollow == "ship" then
		camera.x = ship.x
		camera.y = ship.y
		camera.rot = 0
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "q" then
		love.event.quit()
	end

	if key == "space" then
		if camFollow == "ship" then
			camFollow = "player"
		else
			camFollow = "ship"
		end
	end

	if key == "-" then
		camera:setScale(camera.sx * 2, camera.sy * 2)
	end
	if key == "=" then
		camera:setScale(camera.sx / 2, camera.sy / 2)
	end
end

function love.wheelmoved(x, y)
	if y > 0 then
		camera:setScale(camera.sx / 2, camera.sy / 2)
	elseif y < 0 then
		camera:setScale(camera.sx * 2, camera.sy * 2)
	end
end
