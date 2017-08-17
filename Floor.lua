local Entity = require("Entity")

local Floor = {}
Floor.__index = Floor
setmetatable(Floor, Entity)

function Floor.create(x, y, gridX, gridY)
	image = love.graphics.newImage("img/floor.png")
	local self = Entity.create(x, y, gridX, gridY, image)
	self.type = Entity.TYPE_FLOOR
	setmetatable(self, Floor)

	return self
end

return Floor;