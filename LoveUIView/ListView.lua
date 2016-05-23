local path = (...):match("(.-)[^%.]+$")
local ListView = require (path.."class").extends(require (path.."View"),"ListView")

------------------------------------------
-- Public functions
------------------------------------------

ListView.Direction = {
	Horizontal = 0, Vertical = 1
}

function ListView.new(x,y,width,height,scrollDirection)
	local self = ListView.newObject(x,y,width,height)
	self.scrollDirection = ListView.Direction[scrollDirection]
	self.isDragging = false
	self.delegate = nil
	return self
end

function ListView:mousepressed(x,y,b)
	if not self:sub_mousepressed(x,y,b) then
		self.isDragging = true
	end
end

function ListView:mousemoved(x,y,dx,dy)
	if not self.super:mousemoved(x,y,dx,dy) and self.isDragging then
		-- Scroll action
	end
end

function ListView:mousereleased(x,y,b)
	self:sub_mousereleased()
	self.isDragging = false
end

return ListView