--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local View = require ((...):match("(.-)[^%.]+$").."class").new("View")

local subViewWithPoint, linkToScreen, unlinkToScreen

------------------------------------------
-- Public functions
------------------------------------------

function View.new(x,y,width,height)
  local self = View.newObject()
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.subViews = {}
  self.backgroundColor = {255,255,255}
  self.borderColor = {0,0,0,0}
  self.borderWidth = 1
  self.borderRadius = {0,0}
  self.mouse_over = false
  self.interactionEnabled = true
  self.pivot = {0,0}
  return self
end

function View:update(dt)
  for i=1,#self.subViews do
    self.subViews[i]:update(dt)
  end
end

function View:setInteraction(set)
  if self.interactionEnabled and not set then
    self:clearMouse()
  end
  self.interactionEnabled = set
end

function View:clearMouse()
  self.mouse_over = false
  for i=1,#self.subViews do
    self.subViews[i]:clearMouse()
  end
end

function View:mousepressed(x,y,b)
  self:sub_mousepressed(x,y,b)
end

function View:sub_mousepressed(x,y,b)
  local v = subViewWithPoint(self,x,y)
  if v ~= nil then
    v:mousepressed(x-v.x,y-v.y,b)
    return true
  end
  return false
end

function View:mousemoved(x,y,dx,dy)
  self:sub_mousemoved(x,y,dx,dy)
end

function View:sub_mousemoved(x,y,dx,dy)
  local v = subViewWithPoint(self,x,y)
  if v ~= nil then
    v:mousemoved(x-v.x,y-v.y,dx,dy)
    return true
  end
  return false
end

function View:mousereleased(x,y,b)
  self:sub_mousereleased(x,y,b)
end

function View:sub_mousereleased(x,y,b)
  local v = subViewWithPoint(self,x,y)
  if v ~= nil then
    v:mousereleased(x-v.x,y-v.y,b)
    return true
  end
  return false
end

function View:setCenter(x,y)
  self.x = x-self.width/2
  self.y = y-self.height/2
end

function View:wheelmoved(dx,dy,x,y)
  self:sub_wheelmoved(dx,dy,x,y)
end

function View:sub_wheelmoved(dx,dy,x,y)
  if x == nil then
    x,y = love.mouse.getPosition()
  end
  local v = subViewWithPoint(self,x,y)
  if v ~= nil then
    v:wheelmoved(dx,dy,x,y)
    return true
  end
  return false
end

function View:resize(rw,rh,rec)
  rec = rec or true
  self.width = self.width * rw
  self.height = self.height * rh
  self.x = self.x * rw
  self.y = self.y * rh
  if rec then
    for i=1,#self.subViews do
      self.subViews[i]:resize(rw,rh,rec)
    end
  end
end

function View:keypressed(key)
  for i=1,#self.subViews do
    self.subViews[i]:keypressed(key)
  end
end

function View:addSubView(view)
  table.insert(self.subViews,view)
  linkToScreen(view,self.screen)
  view.parent = self
end

function View:bringToFront()
  if self.parent then
    local subs = self.parent.subViews
    local v
    for i=1,#self.subViews do
      if self.subViews[i]==self then
        table.insert(subs,table.remove(subs,i))
        break
      end
    end
  end
end

function View:bringToBack()
  if self.parent then
    local subs = self.parent.subViews
    local v
    for i=1,#self.subViews do
      if self.subViews[i]==self then
        table.insert(subs,1,table.remove(subs,i))
        break
      end
    end
  end
end

function View:removeFromSuperView()
  if self.parent ~= nil then
    local p = self.parent
    self.parent = nil
    for i,v in pairs(p.subViews) do
      if v==self then table.remove(p.subViews,i) break end end
    unlinkToScreen(self)
  end
end

function View:minX()
  return self.x+self.width*(-self.pivot[1])
end
function View:minY()
  return self.y+self.height*(-self.pivot[2])
end
function View:midX()
  return self.x+self.width*(0.5-self.pivot[1])
end
function View:midY()
  return self.y+self.height*(0.5-self.pivot[2])
end
function View:maxX()
  return self.x+self.width*(1-self.pivot[1])
end
function View:maxY()
  return self.y+self.height*(1-self.pivot[2])
end

function View:draw()
  self:pre_draw()
  self:during_draw()
  self:pos_draw()
end

function View:pre_draw()
  love.graphics.push()
  love.graphics.translate(self.x,self.y)
end

function View:during_draw()
  love.graphics.setColor(self.backgroundColor)
  love.graphics.rectangle("fill",-self.pivot[1]*self.width,-self.pivot[2]*self.height,self.width,self.height,self.borderRadius[1],self.borderRadius[2])
  love.graphics.setColor(255,255,255)
end

function View:pos_draw()
  for i=1,#self.subViews do self.subViews[i]:draw() end
  love.graphics.setColor(self.borderColor)
  love.graphics.setLineWidth(self.borderWidth)
  love.graphics.rectangle("line",0,0,self.width,self.height)
  love.graphics.setColor(255,255,255)
  love.graphics.pop()
end

function View:containsPoint(x,y)
  return self:minX()<x and x<self:maxX() and self:minY()<y and y<self:maxY()
end

function View:convertPoint(x,y)
  return x-self.x,y-self.y
end

------------------------------------------
-- Private functions
------------------------------------------
subViewWithPoint = function(self,x,y)
  self.mouse_over = true
  local resp = nil
  local v
  for i=1,#self.subViews do
    v = self.subViews[i]
    if v:containsPoint(x,y) then 
      if v.interactionEnabled then resp = v end
    else v:clearMouse() end
  end
  return resp
end

linkToScreen = function(self,screen)
  self.screen = screen
  for i=1,#self.subViews do
    linkToScreen(self.subViews[i],screen)
  end
end

unlinkToScreen = function(self)
  linkToScreen(self,nil)
end

return View