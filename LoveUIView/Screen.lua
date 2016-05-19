local path = (...):match("(.-)[^%.]+$")
local View = require (path.."View")

local Screen = require (path.."class").new("Screen")

local searchView

------------------------------------------
-- Public functions
------------------------------------------

function Screen.new()
	local self = Screen.newObject()
	self.view = View.new(0,0,love.graphics.getDimensions())
	return self
end

function Screen:update(dt)
	self.view:update(dt)
end

function Screen:setInteraction(set)
	self.view:setInteraction(set)
end

function Screen:mousepressed(x,y,b)
	if self.view.interactionEnabled then self.view:mousepressed(x,y,b) end
end

function Screen:wheelmoved(x,y)
	if self.view.interactionEnabled then self.view:wheelmoved(x,y) end
end

function Screen:mousemoved(x,y,dx,dy)
	if self.view.interactionEnabled then self.view:mousemoved(x,y,dx,dy) end
end

function Screen:mousereleased(x,y,b)
	if self.view.interactionEnabled then self.view:mousereleased(x,y,b) end
end

function Screen:keypressed(key)
	if self.view.interactionEnabled then self.view:keypressed(key) end
end

function Screen:viewContainsPoint(view, x,y)
	local v = self.view.subViews
	local didFind
	while #v > 0 do
		didFind = false
		for i,sub in ipairs(v) do
			local c = sub:containsPoint(x,y)
			if view==sub then return c
			elseif c then
				v=sub.subViews
				didFind=true
				break
			end
		end
		if not didFind then return false end
	end
	return false
end

function Screen:convertPointToView(view, x,y)
	return searchView(self.view,view,x,y)
end

function Screen:draw()
	self.view:draw()
end

------------------------------------------
-- Private functions
------------------------------------------

function searchView(view,proc,x,y)
	local nx,ny
	for i,v in ipairs(view.subViews) do
		--nx,ny = v:convertPoint(x,y)
		if proc==v then return x,y end
		nx,ny = searchView(v,proc,v:convertPoint(x,y))
		if nx then return nx,ny end
	end
	return nil
end

return Screen