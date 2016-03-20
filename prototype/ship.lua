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

function pix_id(hex)
	if hex == "000000" then
		return "empty"
	end
	if hex == "455A64" then
		return "wall"
	end
	if hex == "212121" then
		return "floor"
	end
	if hex == "42A5F5" then
		return "glass"
	end
	if hex == "0D47A1" then
		return "flight_control"
	end
	if hex == "4A148C" then
		return "door"
	end
	if hex == "004D40" then
		return "fuel_control"
	end
	if hex == "64DD17" then
		return "fuel_line"
	end
	if hex == "FFEA00" then
		return "thruster"
	end
	if hex == "D50000" then
		return "weapon"
	end
	if hex == "D32F2F" then
		return "weapon_control"
	end

	return hex
end

function ship:load()
	self.image = love.graphics.newImage("ship.png")
	self.map = {}
	local imageData = self.image:getData()
	local h = imageData:getHeight()
	local w = imageData:getWidth()
	for y=1, h do
		for x=1, w do
			-- print(x .. " " .. w .. "\n" .. y .. " " .. h)
			r, g, b, a = imageData:getPixel(x-1, y-1)
			hex = rgb_to_hex(r, g, b)
			if not self.map[y] then self.map[y]={} end
			self.map[y][x] = pix_id(hex)
		end
	end

	self.computerbeepSound = love.audio.newSource("computerbeep.ogg")
	self.fireSound = love.audio.newSource("fire.ogg")
	self.thrustSound = love.audio.newSource("thrust.ogg")
	self.thrustSound:setLooping(true)

	print_r(self.map)
end

function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
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

function rgb_to_hex(r, g, b)
	-- local hex = DEC_HEX(r) .. DEC_HEX(g) .. DEC_HEX(b)
	local hex = string.format("%02X%02X%02X", r, g, b)
	return hex
end

function rgba_to_hex(r, g, b, a)
	-- local hex = DEC_HEX(r) .. DEC_HEX(g) .. DEC_HEX(b) .. DEC_HEX(a)
	local hex = string.format("%04X%04X%04X%04X", r, g, b, a)
	return hex
end

function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    if IN == 0 then
    	return "00"
    end
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end
