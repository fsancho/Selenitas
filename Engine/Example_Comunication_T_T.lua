local pl            = require 'pl'
local pretty        = require 'pl.pretty'
local Agent         = require 'Engine.classes.class_agent'
local Collection    = require 'Engine.classes.class_collection'
local Params        = require 'Engine.classes.class_params'
local Patch         = require 'Engine.classes.class_patch'
local utils         = require 'Engine.utilities'
local utl           = require 'pl.utils'
local lambda        = utl.string_lambda
local first_n       = utils.first_n
local last_n        = utils.last_n
local member_of     = utils.member_of
local one_of        = utils.one_of
local n_of          = utils.n_of
local ask           = utils.ask
local setup         = utils.setup
local run           = utils.run
local create_patches= utils.create_patches


-- "COMUNICATION_T_T"
-- Agents are created and randomly positioned in the grid of patches
-- A message is given to one of them
-- Agents will share the message with others in the same patch.
-- The simulation ends when all agents have the message.




-- Count and print the number of agents in each patch

local function print_current_config()

    ask(Patches, function(patch)
        patch.label = #People:with( function(person)
            return person.xcor == patch.xcor and person.ycor == patch.ycor
        end)
    end)

    for i = Config.ysize,1,-1 do
        local line = ""
        for j = 1, Config.xsize do
            line = line .. Patches.agents[j..','..i].label .. ', '
        end
        print(line)
    end
end


-- Each patch has 8 neighbour. This function updates the xcor and ycor params of an angent
--  0 0 0        0 0 x
--  0 x 0   ->   0 0 0
--  0 0 0        0 0 0
-- We are considering that the extremes of the grid of pathes are connected.

local function go_to_random_neighbour(x)

    local changes = { {0,1},{0,-1},{1,0},{-1,0},{1,1},{1,-1},{-1,1},{-1,-1} }
    local choose  = math.random(#changes)

    -- Agents that cross a boundary will appear on the opposite side of the grid
    x.xcor = (x.xcor + changes[choose][1]) % Config.xsize
    x.ycor = (x.ycor + changes[choose][2]) % Config.ysize

    if x.xcor == 0 then x.xcor = Config.xsize end
    if x.ycor == 0 then x.ycor = Config.ysize end
end


-- Agents with the message will share it with other agents in the same patch
local function comunicate(x)

    if x.message then
        local my_x, my_y = x.xcor, x.ycor
        ask(
            People:with(function(other)
                return x ~= other and other.xcor == my_x and other.ycor == my_y
            end),

            function(other)        
                other.message = true
            end
        )
    end

end


Config = Params({
    ['start'] = true,
    ['go']    = true,
    ['ticks'] = 200,
    ['xsize'] = 15,
    ['ysize'] = 15
})

-- The anonymous function in this call is executed once by the setup function
-- defined in utilities.lua
setup(function()

    -- Params is a class which contains the parameters of the interface (sliders, inputs, booleans,etc)

    

    Patches = create_patches(Config.xsize, Config.ysize)

    -- Create a new collection
    People = Collection()

    -- Populate the collection with Agents.
    People:create_n( 10, function()
        return Agent({
            ['xcor']    = math.random(Config.xsize),
            ['ycor']    = math.random(Config.ysize),
            ['message'] = false
        })
    end)

    ask(one_of(People), function(agent)
        agent.message = true
    end)

end)


-- This function is executed until the stop condition is reached, or until
-- the number of iterations equals the number of ticks specified inf Config object
run(function()

    print("========= tick ".. T+1 .. " ===========")

    -- Stop condition
    if #People:with(lambda '|x| x.message == false') == 0 then
        Config.go = false
        return
    end

    ask(People, function(person)
        go_to_random_neighbour(person)
        comunicate(person)
    end)


    print_current_config()

    print("=============================")
    print(#People:with(lambda '|x| x.message == false'))
end)


