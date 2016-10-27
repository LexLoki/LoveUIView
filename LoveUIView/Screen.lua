--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
	self.view.screen = self
	self.responder = nil
	self._presented = nil
	self._presenting = nil
	return self
end

function Screen:presentScreen(scr)
	if self._presented then self._presented:dismiss() end
	self._presented = scr
end

function Screen:dismiss()
	if self._presenting then self._presenting._presented = nil self._presenting = nil end
end

function Screen:update(dt)
	self.view:update(dt)
end

function Screen:setInteraction(set)
	self.view:setInteraction(set)
end

function Screen:mousepressed(x,y,b)
	if self._presented then self._presented:mousepressed(x,y,b) do return end end
	if self._responder ~= nil then self._responder:endResponder() end
	self._responder = nil
	if self.view.interactionEnabled then self.view:mousepressed(x,y,b) end
end

function Screen:wheelmoved(x,y)
	if self._presented then self._presented:wheelmoved(x,y) do return end end
	if self.view.interactionEnabled then self.view:wheelmoved(x,y) end
end

function Screen:mousemoved(x,y,dx,dy)
	if self._presented then self._presented:mousemovedd(x,y,dx,dy) do return end end
	if self.view.interactionEnabled then self.view:mousemoved(x,y,dx,dy) end
end

function Screen:mousereleased(x,y,b)
	if self._presented then self._presented:mousereleased(x,y,b) do return end end
	if self.view.interactionEnabled then self.view:mousereleased(x,y,b) end
end

function Screen:becomeResponder(view)
	if self._responder~=nil then self._responder:endResponder() end
	self._responder = view
	self._responder:becameResponder()
end

function Screen:keypressed(key)
	if self._presented then self._presented:keypressed(key) do return end end
	if self.view.interactionEnabled then
		self.view:keypressed(key)
		if self._responder ~= nil then
			self._responder:respondKey(key)
		end
	end
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