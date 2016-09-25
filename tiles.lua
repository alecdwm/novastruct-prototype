tiles = {}

function tiles:getTileTypeFromColor(hex)
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
		-- TODO: Write shader to set pixels outside of ship to black unless
		--       there is a direct path from the pixel to the player which
		--        passes through a 'glass' tile
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
