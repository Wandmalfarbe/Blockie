local Entity = require("Entity")

local Wall = {}
Wall.__index = Wall
setmetatable(Wall, Entity)

function Wall.create(x, y, gridX, gridY)
	image = love.graphics.newImage("img/wall.png")
	local self = Entity.create(x, y, gridX, gridY, image)
	self.type = Entity.TYPE_WALL
	setmetatable(self, Wall)

	return self
end

return Wall;