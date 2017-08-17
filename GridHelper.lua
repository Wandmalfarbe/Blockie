local Entity = require("Entity")

local GridHelper = { STATE_DEACREASING = 0, STATE_INCREASING = 1, MIN_ALPHA = 0, MAX_ALPHA = 60}
GridHelper.__index = GridHelper
setmetatable(GridHelper, Entity)

function GridHelper.create(x, y, gridX, gridY, image)
	local self = Entity.create(x, y, gridX, gridY, image)
	setmetatable(self, GridHelper)

	self.alpha = GridHelper.MAX_ALPHA
	self.state = GridHelper.STATE_DECREASING
	return self
end

function GridHelper:update(dt)

	if(self.state == GridHelper.STATE_DECREASING) then
		self.alpha = self.alpha - dt*200
	else 
		self.alpha = self.alpha + dt*200
	end

	if(self.alpha < GridHelper.MIN_ALPHA) then
		self.alpha = GridHelper.MIN_ALPHA
		self.state = GridHelper.STATE_INCREASING
	elseif(self.alpha > GridHelper.MAX_ALPHA) then
		self.alpha = GridHelper.MAX_ALPHA
		self.state = GridHelper.STATE_DECREASING
	end
end

function GridHelper:draw()
	love.graphics.setColor(255, 255, 255, self.alpha)

	for x = 0, self.world.gridCellsX do
		for y = 0, self.world.gridCellsY do
			screenX, screenY = self.world:toScreenCoords(x, y)
			love.graphics.rectangle("fill", screenX, screenY, self.world.cellWidth-1, self.world.cellHeight-1)
		end
	end
	love.graphics.setColor(255, 255, 255, 255)
end

return GridHelper;