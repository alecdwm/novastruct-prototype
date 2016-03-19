ship = {}
ship.x = 0
ship.y = 0
ship.vx = 0
ship.vy = 0
ship.rot = 0
ship.vrot = 0
ship.dragFactor = 0.2
ship.rotDragFactor = 1

ship.thrust = 40
ship.torque = 6
ship.image = nil

ship.controlled = false
ship.dragEnabled = false

-- 0 = empty
-- 1 = wall
-- 2 = floor
-- 3 = glass
-- 4 = control panel
-- 5 = airlock
-- 6 = fuel line
-- 7 = engine

ship.map = {
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 2, 2, 3, 3, 3, 2, 2, 1, 1, 0},
	{0, 1, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{5, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{5, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
	{0, 1, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 1},
	{0, 0, 1, 1, 2, 2, 6, 6, 6, 2, 2, 1, 1, 0},
	{0, 0, 0, 0, 1, 1, 1, 6, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 0, 7, 7, 7, 7, 7, 0, 0, 0, 0},
}

function ship:load()
	self.image = love.graphics.newImage("ship.png")
end

function ship:update(dt)
	if self.controlled then
		-- input
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			self.vrot = self.vrot - self.torque * dt
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			self.vrot = self.vrot + self.torque * dt
		end

		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			self.vx = self.vx + math.sin(self.rot) * self.thrust * dt
			self.vy = self.vy - math.cos(self.rot) * self.thrust * dt
		end
	end

	-- movement
	self.rot = self.rot + self.vrot * dt
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	if self.dragEnabled then
		-- drag
		self.vrot = self.vrot - self.vrot * self.rotDragFactor* dt
		self.vx = self.vx - self.vx * self.dragFactor * dt
		self.vy = self.vy - self.vy * self.dragFactor * dt
	end
end

function ship:draw()
	love.graphics.draw(self.image, self.x, self.y, self.rot, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function ship:keypressed(key, scancode, isrepeat)
	if key == "lshift" or key == "rshift" then
		self.dragEnabled = not self.dragEnabled
	end
end
