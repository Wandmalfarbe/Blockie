local Entity = { TYPE_FLOOR = 0, TYPE_WALL = 1, TYPE_PLAYER = 2, TYPE_BALL = 3, TYPE_END = 4, TYPE_HOLE = 5}
Entity.__index = Entity

function Entity.create(x, y, gridX, gridY, image)
	local self = setmetatable({}, Entity)

	self.x, self.y = x, y
	self.gridX, self.gridY = gridX, gridY
	self.image = image
	self.keypressFiredAlready = false

	return self
end

function Entity:update(dt)
	
end

function Entity:draw()

	local y = self.y
	-- origin is bottom left of the tile
	if self.image:getHeight() > self.image:getWidth() then
		y = self.y - (self.image:getHeight() - self.world.cellHeight)
	end

	love.graphics.draw(self.image, self.x, y)
end

function Entity:keypressed()

end

function Entity:getType()
	return self.type
end

function Entity:insertedIntoWorld(world)
	self.world = world
end

function Entity:smoothMoveToGridPos(newGridX, newGridY)

	self.destX, self.destY = self.world:toScreenCoords(newGridX, newGridY)
	self.isMoving = true

	-- move in grid
	self.world:deleteEntityAt(self, self.gridX, self.gridY)
	self.world:insertEntityAt(self, newGridX, newGridY)

	-- update internal grid position
	self.gridX = newGridX
	self.gridY = newGridY
end

return Entity