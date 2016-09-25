camera = {}
camera.x = 0
camera.y = 0
camera.sx = 1
camera.sy = 1
camera.rot = 0
camera.follow = "player"

function camera:update(dt)
	if camera.follow == "player" then
		camera.x = player.parent.x
		camera.y = player.parent.y
		camera.rot = player.parent.rot
	elseif camera.follow == "ship" then
		camera.x = ship.x
		camera.y = ship.y
		camera.rot = 0
	end
end

function camera:set()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	love.graphics.rotate(-self.rot)
	love.graphics.translate(-love.graphics.getWidth()/2, -love.graphics.getHeight()/2)
	love.graphics.scale(1/self.sx, 1/self.sy)
	love.graphics.translate(-self.x + love.graphics.getWidth() / 2 * self.sx, -self.y + love.graphics.getHeight() / 2 * self.sy)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function camera:rotate(rot)
	self.rot = self.rot + rot
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.sx = self.sx * sx
	self.sy = self.sy * (sy or sx)
end

function camera:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function camera:setScale(sx, sy)
	self.sx = sx or self.sx
	self.sy = sy or self.sy
end

function camera:mousePosition()
	return love.mouse.getX() * self.sx + self.x, love.mouse.getY() * self.sy + self.y
end

function camera:getBoundsWorldCoords()
	-- get the camera bounds (top left, top right, bottom left, bottom right) in world space
	norotxtl = self.x - love.graphics.getWidth()  / 2 * self.sx
	norotytl = self.y - love.graphics.getHeight() / 2 * self.sy

	norotxtr = self.x + love.graphics.getWidth()  / 2 * self.sx
	norotytr = self.y - love.graphics.getHeight() / 2 * self.sy

	norotxbl = self.x - love.graphics.getWidth()  / 2 * self.sx
	norotybl = self.y + love.graphics.getHeight() / 2 * self.sy

	norotxbr = self.x + love.graphics.getWidth()  / 2 * self.sx
	norotybr = self.y + love.graphics.getHeight() / 2 * self.sy

	-- orientate with camera rotation
	xtl = self.x + (norotxtl-self.x) * math.cos(self.rot) + (norotytl-self.y) * math.sin(self.rot)
	ytl = self.y + (norotxtl-self.x) * math.sin(self.rot) - (norotytl-self.y) * math.cos(self.rot)

	xtr = self.x + (norotxtr-self.x) * math.cos(self.rot) + (norotytr-self.y) * math.sin(self.rot)
	ytr = self.y + (norotxtr-self.x) * math.sin(self.rot) - (norotytr-self.y) * math.cos(self.rot)

	xbl = self.x + (norotxbl-self.x) * math.cos(self.rot) + (norotybl-self.y) * math.sin(self.rot)
	ybl = self.y + (norotxbl-self.x) * math.sin(self.rot) - (norotybl-self.y) * math.cos(self.rot)

	xbr = self.x + (norotxbr-self.x) * math.cos(self.rot) + (norotybr-self.y) * math.sin(self.rot)
	ybr = self.y + (norotxbr-self.x) * math.sin(self.rot) - (norotybr-self.y) * math.cos(self.rot)

	return xtl, ytl, xtr, ytr, xbl, ybl, xbr, ybr
end

function camera:inBoundsWorldCoords(x, y)
	local ax, ay, bx, by, cx, cy, dx, dy = self:getBoundsWorldCoords()

	bax = bx - ax
	bay = by - ay
	dax = dx - ax
	day = dy - ay

	if ((x - ax) * bax + (y - ay) * bay < 0) then return false end
	if ((x - bx) * bax + (y - by) * bay > 0) then return false end
	if ((x - ax) * dax + (y - ay) * day < 0) then return false end
	if ((x - dx) * dax + (y - dy) * day > 0) then return false end

	return true
end
