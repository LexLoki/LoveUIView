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
  self.super:clearMouse()
end

function Button:mousepressed(x,y,b)
  if not self:sub_mousepressed(x,y,b) then
    if b==1 then self.mouseOn = true end
  end
end

function Button:mousemoved(x,y,dx,dy)
  self.mouseOn = false
  self.super:mousemoved(x,y,dx,dy)
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