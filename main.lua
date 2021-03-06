require "lib"
require "tiles"
require "camera"
require "player"
require "ship"
require "stars"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	love.graphics.setNewFont("DejaVuSansMono.ttf", 11)

	stars:load()
	player:load()
	ship:load()
	player:setParent(ship)
	ship.x = 280
	ship.y = -80

	camera:setScale(0.05, 0.05)
end

function love.update(dt)
	ship:update(dt)
	player:update(dt)
	camera:update(dt)
	stars:update(dt)
end

function love.draw()
	-- World
	camera:set()

	stars:draw()

	love.graphics.setColor(241/255, 217/255, 26/255, 255/255)
	love.graphics.circle("fill", 0, 0, 50, 32)
	love.graphics.circle("line", 0, 0, 80, 8)

	love.graphics.setColor(17/255, 27/255, 26/255, 255/255)
	love.graphics.circle("fill", 280, -80, 40, 4)
	love.graphics.circle("line", 280, -80, 60, 4)

	love.graphics.setColor(0, 194/255, 204/255, 255/255)
	love.graphics.circle("fill", -300, 200, 80, 32)
	love.graphics.arc("line", -300, 200, 120, 0, 3 * math.pi / 2, 32)

	love.graphics.setColor(240/255, 80/255, 20/255, 255/255)
	love.graphics.rectangle("fill", 100, 100, 80, 50)
	love.graphics.rectangle("line", 90, 90, 100, 70)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	ship:draw()
	player:draw()

	camera:unset()

	-- UI
	love.graphics.printf("Player:\nWASD / ↑←↓→\nSHIFT to sprint\n\nShip:\nWAD / ←↑→\nSPACE to stand\n\nZoom:\nSCROLL / (-/+)", 4, 4, 200, "left")
	love.graphics.print("Novastruct ap0.002", love.graphics.getWidth(), love.graphics.getHeight(), 0, 1, 1, 140, 18)
end

function love.mousepressed(x, y, button, istouch)
	print(camera:mousePosition())
end

function love.keypressed(key, scancode, isrepeat)
	if key == "q" then
		love.event.quit()
	end

	player:keypressed(key, scancode, isrepeat)

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
