--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Script to simulate class and inheritance in Lua
-- Version 2.1 - 2016/05/14

local class

function class.new(name)
  local new_class = {}
  function new_class.newObject(...)
    local sup = new_class:superClass()
    local newinst = {}
    local meta = {}
    if sup == nil then
      meta.__index = new_class
    else
      newinst.super = sup.new(...)
      function meta.__index(table,key)
        local classGet = rawget(new_class,key)
        local superGet = rawget(newinst.super,key)
        return (superGet or classGet or newinst.super[key])
      end
      function meta.__newindex(table, key, value)
        if newinst.super[key] == nil or type(value) == "function" then
          rawset(table,key,value)
        else
          newinst.super[key] = value
        end
      end
    end
    setmetatable(newinst, meta)
    return newinst
  end
  new_class.new = new_class.newObject
  
  function new_class:class()
    return new_class
  end
  function new_class:name()
    return (name == nil and "unknown" or name)
  end
  function new_class:superClass()
    return nil
  end
  function new_class:superClasses()
    local classes = {}
    local curr_class = new_class:superClass()
    while curr_class ~= nil do
      table.insert(classes,curr_class)
      curr_class = curr_class:superClass()
    end
    return classes
  end
  
  function new_class:is_a(someClass)
    local cur_class = new_class
    while cur_class ~= nil do
      if cur_class == someClass then return true
      else cur_class = cur_class:superClass() end
    end
    return false
  end
  
  return new_class
end

function class.extends(baseClass,name)
  local new_class = class_new(name)
  if baseClass~=nil then 
    setmetatable(new_class,{__index=baseClass})
    function new_class:superClass()
      return baseClass
    end
  end
  return new_class
end

return class