--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local path = (...):match("(.-)[^%.]+$")
local class = require (path.."class")
local View = require (path.."View")

local TextField = class.extends(View,"TextField")

local keys = {space = ' '}
local blinkTime = 0.7

------------------------------------------
-- Public functions
------------------------------------------

function TextField.new(x,y,width,height)
	local self = TextField.newObject(x,y,width,height)
	self.text = ''
	self.textColor = {0,0,0}
	self.textAlignment = 'left'
	self.isSelected = false
	self.blinkOn = false
	self.blinkTimer = 0
	return self
end

function TextField:mousepressed(...)
	self:becomeResponder()
end

function TextField:respondKey(key)
	if keys[key] then
		self.text = self.text .. keys[key]
	elseif key=='return' then
		self.text = self.text .. '\n'
	elseif key=='backspace' then
		local l = string.len(self.text)
		if l>0 then
			self.text = string.sub(self.text,0,l-1)
		end
	elseif string.len(key)==1 then
		--[[
		if love.keyboard.isDown('Caps-on') then
			key = string.upper(key)
		end]]
		self.text = self.text .. key
	end
end

function TextField:becomeResponder()
	if self.screen ~= nil then
    self.screen:becomeResponder(self)
  end
end

function TextField:becameResponder()
	self.isSelected = true
	self.blinkOn = true
	self.blinkTimer = blinkTime
end

function TextField:endResponder()
	self.isSelected = false
end

function TextField:update(dt)
	self.super:update(dt)
	if self.isSelected then
		self.blinkTimer = self.blinkTimer-dt
		if self.blinkTimer<0 then
			self.blinkOn = not self.blinkOn
			self.blinkTimer = blinkTime
		end
	end
end

function TextField:draw()
	self:pre_draw()
	self:during_draw()
	self:pos_draw()
end

function TextField:during_draw()
	self.super:during_draw()
	love.graphics.setColor(self.textColor)
	local t = self.text
	if self.isSelected and self.blinkOn then t=t .. '|' end
	love.graphics.printf(t,0,0,self.width,self.textAlignment)
end

return TextField