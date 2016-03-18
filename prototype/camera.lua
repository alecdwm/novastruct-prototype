camera = {}
camera.x = 0
camera.y = 0
camera.sx = 1
camera.sy = 1
camera.rot = 0

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
