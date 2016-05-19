local path = (...):match("(.-)[^%.]+$")
local ImageView = require (path.."class").extends(require (path.."View"),"ImageView")

------------------------------------------
-- Public functions
------------------------------------------

function ImageView.new(x,y,width,height)
  local self = ImageView.newObject(x,y,width,height)
  self.image = nil
  return self
end

function ImageView:draw()
  self:pre_draw()
  self:during_draw()
  self:pos_draw()
end

function ImageView:during_draw()
  self.super:during_draw()
  if self.image ~= nil then
    local w,h = self.image:getDimensions()
    local sx,sy = self.width/w,self.height/h
    local s = sx<sy and sx or sy
    love.graphics.draw(self.image,(self.width-s*w)/2,(self.height-s*h)/2,0,s,s)
  end
end

return ImageView