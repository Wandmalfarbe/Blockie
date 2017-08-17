require("state_splash")
require("state_game")

WIDTH = 240
HEIGHT = 160

local SCALE = 1
local TRANSLATE_X = 0

local focus = true
local isFullscreen = false;

STATE_SPLASH, STATE_GAME = 0, 1

gameStates = {[0]=Splash, [1]=Game}

function love.load()

	love.window.setTitle("Blockie")

	-- No aliasing
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	-- scaling and transformation (fullscreen)
	setScreenAndDrawingParameters()

	Splash.start()
end

local focus = true
function love.focus(f)
	focus = f
end

function love.update(dt)
	gameStates[state]:update(dt)
end

function love.draw()

	love.graphics.push()
	love.graphics.translate(TRANSLATE_X, 0)
	love.graphics.scale(SCALE, SCALE)

	gameStates[state]:draw()

	if not focus then
		love.graphics.setColor(0,0,0,128)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.pop()

	love.graphics.setScissor(TRANSLATE_X, 0, WIDTH*SCALE, HEIGHT*SCALE)
end

function love.keypressed(k)
	gameStates[state]:keypressed(k)
end

function setScreenAndDrawingParameters()
	if isFullscreen == true then
		love.window.setFullscreen(true)

		local sWidth, sHeight = love.window.getDesktopDimensions()

		SCALE = sHeight/HEIGHT
		TRANSLATE_X = (sWidth - WIDTH*SCALE)/2
	else
		local sWidth, sHeight = love.window.getDesktopDimensions()

		SCALE = 4

		love.window.setMode(WIDTH*SCALE, HEIGHT*SCALE, {fullscreen=false})
	end
end