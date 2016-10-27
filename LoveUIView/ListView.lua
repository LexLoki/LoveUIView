--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- IN CONSTRUCTION

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
	if not self:super_mousemoved(x,y,dx,dy) and self.isDragging then
		-- Scroll action
	end
end

function ListView:mousereleased(x,y,b)
	self:sub_mousereleased()
	self.isDragging = false
end

return ListView