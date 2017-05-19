--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Script to simulate class, with inheritance and polymorphism, in Lua
-- Version 2.3
-- github.com/LexLoki/luaclass

local luaclass = {}

local methods = {'class','is_a','superClass','name'}

local function eq(t1,t2)
  local s = rawget(t1,'_lower')
  while s do
    t1 = s
    s = rawget(t1,'_lower')
  end
  local s = rawget(t2,'_lower')
  while s do
    t2 = s
    s = rawget(t2,'_lower')
  end
  return rawequal(t1, t2)
end

local function getter(table,key,cl,isSuper)
  isSuper = isSuper or false
  local i,s
  for i,s in pairs(methods) do
    if s==key then return rawget(cl,key),'f' end
  end
  local inst = table
  if not isSuper then
    local method = rawget(inst,'_lower')
    while method do
      inst = method
      method = rawget(inst,'_lower')
    end
  end
  while inst do
    method = rawget(inst:class(),key)
    if method ~= nil then return inst,type(method),method,false end
    s = rawget(inst,'super')
    if s then
      method = rawget(s,key)
      if method ~= nil then return s,type(method),method,true end
    end
    inst = s
  end
  return nil
end

function luaclass.new(name)
  local new_class = {}
  function new_class.newObject(...)
    local sup = new_class:superClass()
    local newinst = {}
    local meta = {}
    if sup == nil then
      --meta.__index = new_class
    else
      newinst.super = sup.new(...)
      rawset(newinst.super,'_lower',newinst)
      --newinst.super._lower = newinst --*
    end
    function meta.__index(table,key)
        local r,t,m,k
        if string.sub(key,1,6) == 'super_' then
          local inst = rawget(table,'super')
          k = string.sub(key,7)
          r,t,m = getter(inst,k,inst:class(),true)
        else
          r,t,m,ii = getter(table,key,new_class)
        end
        if t == 'function' then
          if ii then
            return m
          else
            return function(instance,...)
              return m(r,...)
            end
          end
        elseif t=='f' then return r
        elseif r then return m
        else return nil
        end
        --[[ Old implementation
        local classGet = rawget(new_class,key)
        local superGet = rawget(newinst.super,key)
        return (superGet or classGet or newinst.super[key])
        ]]
      end
      
      function meta.__newindex(table, key, value)
        --local tt = newinst.super
        --tt = rawget(tt,key)
        --[[
        if newinst.super[key] == nil or type(value) == "function" then
          rawset(table,key,value)
        else
          newinst.super[key] = value
        end]]
        local t = rawget(table,'super')
        while t do table = t t = rawget(table,'super') end
        rawset(table,key,value)
      end
      meta.__eq = eq
    setmetatable(newinst, meta)
    return newinst
  end
  new_class.new = new_class.newObject
  
  function new_class:class()
    return new_class
  end
  function new_class:name()
    return name or 'unkwnown'
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
      if cur_class:name() == someClass:name() then return true
      else cur_class = cur_class:superClass() end
    end
    return false
  end
  
  return new_class
end

function luaclass.extends(baseClass,name)
  local new_class = luaclass.new(name)
  if baseClass~=nil then
    setmetatable(new_class,{__index=baseClass})
    function new_class:superClass()
      return baseClass
    end
  end
  return new_class
end

setmetatable(luaclass, {__call = function(t,...) return luaclass.new(...) end})

return luaclass