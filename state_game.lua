local Floor = require("Floor")
local Wall = require("Wall")
local Player = require("Player")
local Ball = require("Ball")
local End = require("End")
local Hole = require("Hole")

local Entity = require("Entity")

local GridHelper = require("GridHelper")

Game = {}

function Game.start()
	time = 0

	-- global variables
	Game.map = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 4, 3, 0, 1, 1, 0, 3, 3, 0, 0, 0, 0, 0, 1}, 
		{1, 0, 0, 0, 0, 4, 0, 3, 0, 0, 0, 0, 0, 0, 1},
		{1, 0, 3, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1},
		{1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 4, 3, 0, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0, 1}, 
		{1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	}
	Game.entities = {}
	Game.grid = {}

	Game.gridCellsX = #Game.map[1]
	Game.gridCellsY = #Game.map
	Game.cellWidth = WIDTH/Game.gridCellsX
	Game.cellHeight = HEIGHT/Game.gridCellsY

	Game:prepareGrid()

	local gridHelper = GridHelper.create(0, 0, imgWall)
	Game:insertMapEntities(Game.map)

	-- switch to the Game state
	state = STATE_GAME
end

-- Grid stuff

function Game:getEntitiesAt(gridX, gridY)
	return self.grid[gridY+1][gridX+1]
end

function Game:containsEntityTypeAt(entityType, gridX, gridY)
	local contents = self.grid[gridY+1][gridX+1]
	for index,entity in ipairs(contents) do 
		if(entity:getType() == entityType) then
			return true
		end
	end
	return false
end

function Game:getFirstEntityOfTypeAt(entityType, gridX, gridY)
	local contents = self.grid[gridY+1][gridX+1]
	for index,entity in ipairs(contents) do 
		if(entity:getType() == entityType) then
			return entity
		end
	end
	return false
end

function Game:insertEntityAt(entityToInsert, gridX, gridY)

	-- Put entity into grid
	table.insert(self.grid[gridY+1][gridX+1], entityToInsert)

	-- Link entity to world
	entityToInsert:insertedIntoWorld(self)
end

function Game:deleteEntityAt(entityToDelete, gridX, gridY)
	local contents = self.grid[gridY+1][gridX+1]
	for index,entity in ipairs(contents) do 
		if(entity == entityToDelete) then
			table.remove(self.grid[gridY+1][gridX+1], index)
		end
	end
end

function Game:prepareGrid()

	for gridY = 1, self.gridCellsY do
		self.grid[gridY] = {}
		for gridX = 1, self.gridCellsX do
			self.grid[gridY][gridX] = {}
		end
	end
end

function Game:toScreenCoords(gridX, gridY)
	return gridX * self.cellWidth, gridY * self.cellHeight
end

function Game:isAccessible(gridX, gridY)
	return (
		gridX >= 0 and 
		gridY >= 0 and 
		gridX < self.gridCellsX and 
		gridY < self.gridCellsY and 
		self:containsEntityTypeAt(Entity.TYPE_WALL, gridX, gridY) == false and
		self:containsEntityTypeAt(Entity.TYPE_END, gridX, gridY) == false
	)
end

function Game:getPosInDirection(currentX, currentY, direction)

	local newX = currentX
	local newY = currentY

	if direction == 'right' then
		newX = currentX + 1
	elseif direction == 'left' then
		newX = currentX - 1
	elseif direction == 'down' then
		newY = currentY + 1
	elseif direction == 'up' then
		newY = currentY - 1
	end

	return newX, newY
end

-- Map stuff

function Game:insertMapEntities(map)

	for gridY = 1, self.gridCellsY do
		for gridX = 1, self.gridCellsX do
			local entityType = map[gridY][gridX]
			local screenX, screenY = self:toScreenCoords(gridX-1, gridY-1)

			if entityType == 0 then --floor
				entity = Floor.create(screenX, screenY, gridX-1, gridY-1)
			elseif entityType == 1 then --wall
				entity = Wall.create(screenX, screenY, gridX-1, gridY-1)
			elseif entityType == 2 then --player
				entity = Player.create(screenX, screenY, gridX-1, gridY-1)
			elseif entityType == 3 then --ball
				entity = Ball.create(screenX, screenY, gridX-1, gridY-1)
			elseif entityType == 4 then --end
				entity = End.create(screenX, screenY, gridX-1, gridY-1)
			elseif entityType == 5 then --hole
				entity = Hole.create(screenX, screenY, gridX-1, gridY-1)
			end

			if(entityType ~= 0) then
				local floor = Floor.create(screenX, screenY, gridX-1, gridY-1)
				self:insertEntityAt(floor, gridX-1, gridY-1)
			end

			self:insertEntityAt(entity, gridX-1, gridY-1)
		end
	end
end

-- Game stuff

function Game:update(dt)
	for gridY = 1, self.gridCellsY do
		for gridX = 1, self.gridCellsX do
			for entity = 1, #self.grid[gridY][gridX] do
				self.grid[gridY][gridX][entity]:update(dt)
			end
		end
	end
end

function Game:draw()
	for gridY = 1, self.gridCellsY do
		for gridX = 1, self.gridCellsX do
			for entity = 1, #self.grid[gridY][gridX] do
				self.grid[gridY][gridX][entity]:draw()
			end
		end
	end
end

function Game:keypressed(key)
	for gridY = 1, self.gridCellsY do
		for gridX = 1, self.gridCellsX do
			for entity = 1, #self.grid[gridY][gridX] do

				if(self.grid[gridY][gridX][entity].keypressFiredAlready) ~= true then
					self.grid[gridY][gridX][entity].keypressFiredAlready = true
					self.grid[gridY][gridX][entity]:keypressed(key)
				end
			end
		end
	end

	for gridY = 1, self.gridCellsY do
		for gridX = 1, self.gridCellsX do
			for entity = 1, #self.grid[gridY][gridX] do
				self.grid[gridY][gridX][entity].keypressFiredAlready = false
			end
		end
	end

	if key == "escape" then
		love.event.quit()
	end
end