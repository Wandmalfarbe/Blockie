Splash = {}

function Splash.start()
	state = STATE_SPLASH
	time = 0

	splashImg = love.graphics.newImage("img/splash.png")

	Game.start()
end

function Splash.update(dt)
	time = time + dt

	if time > 10 then
		game.start()
	end
end

function Splash.draw()
	if time < 10 then

		love.graphics.draw(splashImg, 0, 0)
	end
end

function Splash.keypressed(k)
	if k == "return" or k == "escape" then
		Game.start()
	end
end