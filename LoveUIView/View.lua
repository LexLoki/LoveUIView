local View = require ((...):match("(.-)[^%.]+$").."class").new("View")

local subViewWithPoint

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
  self.borderColor = {0,0,0}
  self.borderWidth = 1
  self.borderRadius = {0,0}
  self.mouse_over = false
  self.interactionEnabled = true
  return self
end

function View:update(dt)
  for _,v in pairs(self.subViews) do v:update(dt) end
end

function View:setInteraction(set)
  if self.interactionEnabled and not set then
    self:clearMouse()
  end
  self.interactionEnabled = set
end

function View:clearMouse()
  self.mouse_over = false
  for i,v in pairs(self.subViews) do v:clearMouse() end
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

function View:keypressed(key)
  for i,v in pairs(self.subViews) do v:keypressed(key) end
end

function View:addSubView(view)
  table.insert(self.subViews,view)
  view.parent = self
end

function View:bringToFront()
  if self.parent then
    local subs = self.parent.subViews
    for i,v in pairs(subs) do
      if v==self then
        table.insert(subs,table.remove(subs,i))
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
  end
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
  love.graphics.rectangle("fill",0,0,self.width,self.height,self.borderRadius[1],self.borderRadius[2])
  love.graphics.setColor(255,255,255)
  for i,v in ipairs(self.subViews) do v:draw() end
end

function View:pos_draw()
  love.graphics.setColor(self.borderColor)
  love.graphics.setLineWidth(self.borderWidth)
  love.graphics.rectangle("line",0,0,self.width,self.height)
  love.graphics.setColor(255,255,255)
  love.graphics.pop()
end

function View:containsPoint(x,y)
  return self.x<x and x<self.x+self.width and self.y<y and y<self.y+self.height
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
  for i,v in ipairs(self.subViews) do
    if v:containsPoint(x,y) then 
      if v.interactionEnabled then resp = v end
    else v:clearMouse() end
  end
  return resp
end

return View