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
ship.rotDragEnabled = false

function ship:load()
	-- load images
	self.image = love.graphics.newImage("ship.png")

	-- load sounds
	self.computerbeepSound = love.audio.newSource("computerbeep.ogg")
	self.fireSound = love.audio.newSource("fire.ogg")
	self.thrustSound = love.audio.newSource("thrust.ogg")
	self.thrustSound:setLooping(true)

	-- construct map
	self.map = {}
	local imageData = self.image:getData()
	local h = imageData:getHeight()
	local w = imageData:getWidth()
	for y=1, h do
		for x=1, w do
			if not self.map[y] then self.map[y]={} end
			r, g, b, a = imageData:getPixel(x-1, y-1)
			self.map[y][x] = tiles:getTileTypeFromColor(rgb_to_hex(r, g, b))
		end
	end
end

function ship:update(dt)
	self.dragEnabled = true
	self.rotDragEnabled = true

	if self.controlled then
		-- input
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			self.vrot = self.vrot - self.torque * dt
			self.rotDragEnabled = false
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			self.vrot = self.vrot + self.torque * dt
			self.rotDragEnabled = false
		end

		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			self.vx = self.vx + math.sin(self.rot) * self.thrust * dt
			self.vy = self.vy - math.cos(self.rot) * self.thrust * dt
			self.dragEnabled = false
			if not self.thrustSound:isPlaying() then
				self.thrustSound:play()
			end
		else
			if self.thrustSound:isPlaying() then
				self.thrustSound:stop()
			end
		end
	end

	-- movement
	self.rot = self.rot + self.vrot * dt
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	-- drag
	if self.rotDragEnabled then
		self.vrot = self.vrot - self.vrot * self.rotDragFactor* dt
	end
	if self.dragEnabled then
		self.vx = self.vx - self.vx * self.dragFactor * dt
		self.vy = self.vy - self.vy * self.dragFactor * dt
	end
end

function ship:draw()
	love.graphics.draw(self.image, self.x, self.y, self.rot, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function ship:playerInteractFuel()
	self.computerbeepSound:stop()
	self.computerbeepSound:play()
end

function ship:fire(x, y)
	self.fireSound:stop()
	self.fireSound:play()
end
