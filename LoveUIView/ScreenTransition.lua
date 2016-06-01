--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- IN CONSTRUCTION

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