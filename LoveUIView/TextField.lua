local path = (...):match("(.-)[^%.]+$")
local class = require (path.."class")
local View = require (path.."View")

local TextField = class.extends(View,"TextField")

function TextField.new(x,y,width,height)
	local self = TextField.newObject(x,y,width,height)
	self.text = ""
	return self
end

function TextField:selected()

end

function TextField:duringDraw()
	self.super:duringDraw()
	love.graphics.printf(self.text,0,0)
end

return TextField