stars = {}
stars.stardust = {}

function stars:load()
	for i=0, 5000 do
		self.stardust[i] = {}
		self.stardust[i].x = math.random(-1000, 1000)
		self.stardust[i].y = math.random(-1000, 1000)
	end
end

function stars:update(dt)
	for i in ipairs(self.stardust) do
		if camera:inBoundsWorldCoords(self.stardust[i].x, self.stardust[i].y) then
			self.stardust[i].active = true
		else
			self.stardust[i].active = false
		end
	end
end

function stars:draw()
	for i in ipairs(self.stardust) do
		if self.stardust[i].active then
			love.graphics.circle("fill", self.stardust[i].x, self.stardust[i].y, math.random(0.4,0.5), 4)
		end
	end
end
