local path = (...):match("(.-)[^%.]+$")
local View = require (path.."View")

local Screen = require (path.."class").new("Screen")

function Screen.new()
	local self = Screen.newObject()
	self.view = View.new(0,0,love.graphics.getDimensions())
	return self
end

function Screen:update(dt)
	self.view:update(dt)
end

function Screen:setInteraction(set)
	self.view:setInteraction(set)
end

function Screen:mousepressed(x,y,b)
	if self.view.interactionEnabled then self.view:mousepressed(x,y,b) end
end

function Screen:wheelmoved(x,y)
	if self.view.interactionEnabled then self.view:wheelmoved(x,y) end
end

function Screen:mousemoved(x,y,dx,dy)
	if self.view.interactionEnabled then self.view:mousemoved(x,y,dx,dy) end
end

function Screen:mousereleased(x,y,b)
	if self.view.interactionEnabled then self.view:mousereleased(x,y,b) end
end

function Screen:draw()
	self.view:draw()
end

return Screen