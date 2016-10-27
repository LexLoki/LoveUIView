--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local path = (...):match("(.-)[^%.]+$")
local Button = require (path.."class").extends(require (path.."ImageView"),"Button")

------------------------------------------
-- Public functions
------------------------------------------

function Button.new(x,y,width,height)
  local self = Button.newObject(x,y,width,height)
  self.mouseOn = false
  return self
end

function Button:clearMouse()
  self.mouseOn = false
  self:super_clearMouse()
end

function Button:mousepressed(x,y,b)
  if not self:sub_mousepressed(x,y,b) then
    if b==1 then self.mouseOn = true end
  end
end

function Button:mousemoved(x,y,dx,dy)
  self.mouseOn = false
  self:super_mousemoved(x,y,dx,dy)
end

function Button:mousereleased(x,y,b)
  if not self:sub_mousereleased(x,y,b) and self.mouseOn then self:selected() end
  self.mouseOn = false
end

function Button:addTarget(t)
  self.target = t
end

function Button:selected()
  if self.target then self.target(self) end
end

return Button