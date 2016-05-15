local ScreenTransition = require ((...):match("(.-)[^%.]+$").."class").new("ScreenTransition")

function ScreenTransition.new(fromScreen, toScreen, time, callback)
	local self = ScreenTransition.newObject()
	self.screens = {fromScreen,toScreen}
	fromScreen:setInteraction(false)
	toScreen:setInteraction(false)
	toScreen.view.x = love.graphics.getWidth()
	self.speed = -fromScreen.view.x/time
	return self
end

function ScreenTransition:update(dt)
	for i,v in ipairs(self.screens) do v:update(dt) end
	toScreen.x = toScreen.x+self.speed*dt
	if toScreen.x < 0 then
		toScreen.x = 0
		toScreen.setInteraction(true)
		callback()
	end
end

function ScreenTransition:draw()
	for i,v in ipairs(self.screens) do v:draw() end
end

function ScreenTransition:mousepressed(x,y,b)
end
function ScreenTransition:mousemoved(x,y,dx,dy)
end
function ScreenTransition:mousereleased(x,y,b)
end

return ScreenTransition