local Entity = require("Entity")

local Ball = { MOVE_SPEED = 100 }
Ball.__index = Ball
setmetatable(Ball, Entity)

function Ball.create(x, y, gridX, gridY)
	image = love.graphics.newImage("img/ball.png")
	local self = Entity.create(x, y, gridX, gridY, image)
	self.type = Entity.TYPE_BALL
	setmetatable(self, Ball)

	self.isMoving = false;
	self.destX = 0
	self.destY = 0

	return self
end

function Ball:update(dt)

	if(self.isMoving) then

		local dirx = self.destX - self.x
		local diry = self.destY - self.y
		local dist = math.sqrt(dirx^2 + diry^2)
		local toMove = self.MOVE_SPEED * dt

		if dist < toMove then
			self.x = self.destX
			self.y = self.destY
			self.isMoving = false
		else
			self.x = self.x + dirx/dist * dt * self.MOVE_SPEED
			self.y = self.y + diry/dist * dt * self.MOVE_SPEED
		end
	end
end

function Ball:moveTo(direction, count)

	if(count == 0) then
		print("")
	end
	print(count .. ". Move from (" .. self.gridX .. ", " .. self.gridY .. ") " .. direction)

	local newGridX, newGridY = self.world:getPosInDirection(self.gridX, self.gridY, direction);

	print("   to (" .. newGridX .. ", " .. newGridY .. ") ")

	if(self.world:isAccessible(newGridX, newGridY) and self.world:containsEntityTypeAt(Entity.TYPE_BALL, newGridX, newGridY)) then
		local ball = self.world:getFirstEntityOfTypeAt(Entity.TYPE_BALL, newGridX, newGridY)
		ball:moveTo(direction, count+1)
	end
	
	if (self.world:isAccessible(newGridX, newGridY) and self.world:containsEntityTypeAt(Entity.TYPE_BALL, newGridX, newGridY) == false) then

		self:smoothMoveToGridPos(newGridX, newGridY)

		if (self.world:containsEntityTypeAt(Entity.TYPE_HOLE, newGridX, newGridY)) then
			print("Player died")
			self.world:deleteEntityAt(self, newGridX, newGridY)
		end

		return true
	end
	
	return false
end

return Ball;