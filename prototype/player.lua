player = {}
player.worldX = 0 -- set inside the class, read only
player.worldY = 0 -- set inside the class, read only
player.localX = 0
player.localY = 0
player.walkSpeed = 4
player.rot = 0
player.image = nil
player.parent = nil

function player:load()
	self.image = love.graphics.newImage("player.png")
	self.parent = {}
end

function player:update(dt)
	w = love.keyboard.isDown('w')
	a = love.keyboard.isDown('a')
	s = love.keyboard.isDown('s')
	d = love.keyboard.isDown('d')
	local moving = false
	-- if w and not s then
	-- 	moving = true
	-- 	self.rot = 3 * math.pi / 2
	-- 	if a then
	-- 		self.rot = self.rot - math.pi / 4
	-- 	end
	-- 	if d then
	-- 		self.rot = self.rot + math.pi / 4
	-- 	end
	-- 	elseif s and not w then

	if w or a or s or d then
		moving = true
		if w then
			self.rot = 3 * math.pi / 2
		elseif a then
			self.rot = math.pi
		elseif s then
			self.rot = math.pi / 2
		elseif d then
			self.rot = 0
		end
	end

	if moving then
		self.localX = self.localX + math.cos(self.rot) * self.walkSpeed * dt
		self.localY = self.localY + math.sin(self.rot) * self.walkSpeed * dt
	end
end

function player:draw()
	self.worldX = self.parent.x + (self.localX * math.cos(self.parent.rot) - self.localY * math.sin(self.parent.rot))
	self.worldY = self.parent.y + (self.localX * math.sin(self.parent.rot) + self.localY * math.cos(self.parent.rot))


	-- local worldx = self.parent.x + (self.x)
	-- local worldy = self.parent.y + self.y
	love.graphics.draw(self.image, self.worldX, self.worldY, self.parent.rot)
	-- love.graphics.draw(self.image, (self.parent.x or 0) + self.x, (self.parent.y or 0) + self.y, (self.parent.rot or 0) + self.rot, 1, 1)
	-- love.graphics.draw(self.image, round((self.parent.x or 0) + self.x), round((self.parent.y or 0) + self.y), 0)
	-- love.graphics.draw(self.image, round((self.parent.x or 0) + self.x), round((self.parent.y or 0) + self.y), (self.parent.rot or 0) + self.rot, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function player:setParent(parent)
	self.parent = parent
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
