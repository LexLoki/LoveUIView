--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local path = (...):match("(.-)[^%.]+$")
local ImageView = require (path.."class").extends(require (path.."View"),"ImageView")

------------------------------------------
-- Public functions
------------------------------------------

function ImageView.new(x,y,width,height)
  local self = ImageView.newObject(x,y,width,height)
  self.image = nil
  self.shouldFill = true
  return self
end

function ImageView:during_draw()
  self:super_during_draw()
  print('cmon')
  if self.image ~= nil then
    local w,h = self.image:getDimensions()
    local sx,sy = self.width/w,self.height/h
    if not self.shouldFill then
      if sx>sy then sx = sy else sy = sx end
    end
    love.graphics.draw(self.image,(self.width-sx*w)/2,(self.height-sy*h)/2,0,sx,sy)
  end
end

return ImageView