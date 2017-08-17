local Entity = require("Entity")

local Hole = {}
Hole.__index = Hole
setmetatable(Hole, Entity)

function Hole.create(x, y, gridX, gridY)
	image = love.graphics.newImage("img/hole.png")
	local self = Entity.create(x, y, gridX, gridY, image)
	self.type = Entity.TYPE_HOLE
	setmetatable(self, Hole)

	return self
end

return Hole;