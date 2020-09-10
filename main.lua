-- Add Thirdparty folder to package path
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ';Thirdparty/?.lua')
love.filesystem.setCRequirePath(love.filesystem.getCRequirePath() .. ';Native/?.so' .. ';Native/?.dll');

-- Load default window
require("Visual.graphicengine").init()