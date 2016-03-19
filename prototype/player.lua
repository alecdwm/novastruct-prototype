player = {}
player.worldX = 0 -- set inside the class, read only
player.worldY = 0 -- set inside the class, read only
player.localX = 7
player.localY = 7
player.walkSpeed = 5
player.sprintSpeed = 10
player.image = nil
player.parent = nil

player.timeUp = 0
player.timeLeft = 0
player.timeDown = 0
player.timeRight = 0

player.controlMode = "player"

function player:load()
	self.image = love.graphics.newImage("player.png")
	self.parent = {}
end

function player:update(dt)
	if self.controlMode == "player" then
		-- input
		up = love.keyboard.isDown('w') or love.keyboard.isDown('up')
		left = love.keyboard.isDown('a') or love.keyboard.isDown('left')
		down = love.keyboard.isDown('s') or love.keyboard.isDown('down')
		right = love.keyboard.isDown('d') or love.keyboard.isDown('right')
		sprint = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")

		-- countdown timers
		if self.timeUp > 0 then
			self.timeUp = self.timeUp - dt
			if self.timeUp < 0 then self.timeUp = 0 end
		end
		if self.timeLeft > 0 then
			self.timeLeft = self.timeLeft - dt
			if self.timeLeft < 0 then self.timeLeft = 0 end
		end
		if self.timeDown > 0 then
			self.timeDown = self.timeDown - dt
			if self.timeDown < 0 then self.timeDown = 0 end
		end
		if self.timeRight > 0 then
			self.timeRight = self.timeRight - dt
			if self.timeRight < 0 then self.timeRight = 0 end
		end

		-- movement
		local speed = self.walkSpeed
		if sprint then speed = self.sprintSpeed end

		if up and not down and self.timeUp == 0 then
			self:moveStep(self.localX, self.localY-1)
			self.timeUp = (1 / speed)
		end
		if left and not right and self.timeLeft == 0 then
			self:moveStep(self.localX-1, self.localY)
			self.timeLeft = (1 / speed)
		end
		if down and not up and self.timeDown == 0 then
			self:moveStep(self.localX, self.localY+1)
			self.timeDown = (1 / speed)
		end
		if right and not left and self.timeRight == 0 then
			self:moveStep(self.localX+1, self.localY)
			self.timeRight = (1 / speed)
		end
	end

	-- update worldPos
	local localX = self.localX - self.parent.image:getWidth() / 2
	local localY = self.localY - self.parent.image:getHeight() / 2
	self.worldX = self.parent.x + (localX * math.cos(self.parent.rot) - localY * math.sin(self.parent.rot))
	self.worldY = self.parent.y + (localX * math.sin(self.parent.rot) + localY * math.cos(self.parent.rot))
end

function player:draw()
	love.graphics.draw(self.image, self.worldX, self.worldY, self.parent.rot)
end

function player:keypressed(key, scancode, isrepeat)
	if self.controlMode ~= "player" then
		if key == "space" then
			self:unpilotShip()
		end
		return
	end
end

function player:moveStep(x, y)
	if self.parent.map[y+1][x+1] == 0 then
		-- space
		return
	end
	if self.parent.map[y+1][x+1] == 1 then
		-- wall
		return
	end
	if self.parent.map[y+1][x+1] == 2 then
		-- floor
		self.localX = x
		self.localY = y
		return
	end
	if self.parent.map[y+1][x+1] == 3 then
		-- display panel
		return
	end
	if self.parent.map[y+1][x+1] == 4 then
		-- control panel
		self.localX = x
		self.localY = y
		self:pilotShip(self.parent)
	end
end

function player:pilotShip(ship)
	self.piloting = ship
	self.piloting.controlled = true
	self.controlMode = "ship"
	camera.follow = "ship"
end

function player:unpilotShip()
	self.piloting.controlled = false
	self.controlMode = "player"
	camera.follow = "player"
end

function player:setParent(parent)
	self.parent = parent
end
