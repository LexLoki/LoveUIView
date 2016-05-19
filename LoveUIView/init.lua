local path = ... ..'.'
local class = require (path..'class')
local classes = {
	'View',
	'Button',
	'ImageView',
	'Screen',
	'TextField',
	'ListView'
}

local LoveUIView = {
	extends = function(...) return class.extends(...) end
}

for i=#classes,1,-1 do
	local key = table.remove(classes,i)
	LoveUIView[key] = require(path..key)
end

return LoveUIView