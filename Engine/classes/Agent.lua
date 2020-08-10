local class     = require 'pl.class'
local sin       = math.sin
local cos       = math.cos
local rad       = math.rad
local pretty    = require 'pl.pretty'
local pd = pretty.dump

--[[
    Mobiles, Relationals and Cells are Agents also.
]]--

local Agent = class.Agent {
    _init = function(self)
        return self
    end;

    __tostring = function(self)
        local res = "{\n"
        for k,v in pairs(self) do
            if type(v) == 'table' then
                res = res .. '\t'  .. k .. ': {\n'
                for k2,v2 in pairs(v) do
                    res = res .. '\t\t' .. k2 .. ': ' .. type(v2) .. '\n'
                end
                res = res .. '\t}\n'
            else
                res = res .. '\t' .. k .. ': ' .. tostring(v) .. '\n'
            end
        end
        res = res .. '}'
        return res
    end;

}

return Agent