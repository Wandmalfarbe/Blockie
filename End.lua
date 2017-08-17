local Entity = require("Entity")

local End = {}
End.__index = End
setmetatable(End, Entity)

function End.create(x, y, gridX, gridY)
	image = love.graphics.newImage("img/end.png")
	local self = Entity.create(x, y, gridX, gridY, image)
	self.type = Entity.TYPE_END
	setmetatable(self, End)

	return self
end

return End;