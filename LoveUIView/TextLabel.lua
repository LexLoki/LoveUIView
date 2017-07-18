--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local path = (...):match("(.-)[^%.]+$")
local class = require (path.."class")
local View = require (path.."View")
path = nil

local TextLabel = class.extends(View,"TextLabel")

------------------------------------------
-- Public functions
------------------------------------------

function TextLabel.new(x,y,width,height)
	local self = TextLabel.newObject(x,y,width,height)
	self.text = ''
	self.textColor = {0,0,0}
	self.textAlignment = 'left'
	self.isSelected = false
	self.blinkOn = false
	return self
end

function TextLabel:draw_content()
	self:super_draw_content()
	love.graphics.setColor(self.textColor)
	love.graphics.printf(self.text,-self.pivot[1]*self.width,-self.pivot[2]*self.height,self.width,self.textAlignment)
end

return TextLabel