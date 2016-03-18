ship = {}
ship.x = 0
ship.y = 0
ship.vx = 0
ship.vy = 0
ship.rot = 0
ship.vrot = 0

ship.thrust = 40
ship.torque = 6
ship.image = nil

function ship:load()
	self.image = love.graphics.newImage("ship.png")
end

function ship:update(dt)
	if love.keyboard.isDown("left") then
		self.vrot = self.vrot - self.torque * dt
	end
	if love.keyboard.isDown("right") then
		self.vrot = self.vrot + self.torque * dt
	end

	if love.keyboard.isDown("up") then
		self.vx = self.vx + math.sin(self.rot) * self.thrust * dt
		self.vy = self.vy - math.cos(self.rot) * self.thrust * dt
	end

	self.rot = self.rot + self.vrot * dt
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
end

function ship:draw()
	love.graphics.draw(self.image, self.x, self.y, self.rot, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end
