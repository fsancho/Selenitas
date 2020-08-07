local pretty            = require 'pl.pretty'
local pd                = pretty.dump


local _main         = require 'Engine.utilities.utl_main'
local _coll         = require 'Engine.utilities.utl_collections'
local _fltr         = require 'Engine.utilities.utl_filters'
local _chk          = require 'Engine.utilities.utl_checks'
local _act          = require 'Engine.utilities.utl_actions'

local first_n       = _fltr.first_n
local last_n        = _fltr.last_n
local member_of     = _chk.member_of
local one_of        = _fltr.one_of
local n_of          = _fltr.n_of
local ask           = _coll.ask
local fd            = _act.fd
local fd_grid       = _act.fd_grid
local rt            = _act.rt
local lt            = _act.lt

local setup         = _main.setup
local run           = _main.run
local create_patches= _coll.create_patches


Config = Params({
    ['start'] = true,
    ['go']    = true,
    ['ticks'] = 100,
    ['xsize'] = 15,
    ['ysize'] = 15,
    ['num_nodes'] = 10

})

--[[
    In this example we create n nodes and distribute them in the grid. Once this is done,
    each node will create a link with the anothers.
]]--

-- A function to represent the space in a non graphical environment
local function print_current_config()

    print('\n\n========== tick '.. __Ticks .. ' ===========')
    for i=Config.ysize,1,-1 do
        local line = ""
        for j = 1,Config.xsize do
            local target = one_of(Patches:with( function(x) return x:xcor() == i and x:ycor() == j end ) )[1]
            local label = target.label == 'O' and target.label or '_'
            line = line .. label .. ','
        end
        print(line)
    end
    print('=============================\n')
end

local x,y  =  Config.xsize, Config.ysize
local size =  x > y and math.floor(x/2) or math.floor(y/2)

-- In tick 0, all the agents are in the center of the grid, so we only have to divide 360º by
-- the number of agents to obtain the degrees of separation between agents (step).
-- Once this value is obtained, we iterate over the agents. Each agent turns a number of degrees
-- equals to "degrees" variable and increment the value of "degrees" with "step".
local function layout_circle(collection, radius)

    local num = #collection.order
    local step = 360 / num
    local degrees = 0

    for k,v in pairs(collection.agents)do

        local current_agent = collection.agents[k]
        rt(current_agent, degrees)

        -- Use this in a continuous space
        -- fd(current_agent, radius)

        -- Use this in a discrete space
        fd_grid(current_agent, radius)

        degrees = degrees + step
    end

end

setup(function()

    Patches = create_patches(Config.xsize, Config.ysize)

    Nodes = CollectionMobil()
    Nodes:create_n( Config.num_nodes, function()
        return {
            ['pos']     = {size,size},
            ['head']    = 0
        }
    end)

    layout_circle(Nodes, size - 1 )

    -- A new collection to store the links
    Links = CollectionRelational()

    -- Each agent will create a link with the other agents.
    ask(Nodes, function(agent)
        ask(Nodes:others(agent), function(another_agent)
            Links:add({
                    ['source'] = agent,
                    ['target'] = another_agent,
                    ['legend'] = agent.id .. ',' .. another_agent.id
                }
            )
        end)
    end)

    -- This function prints a 0 in the grid position of a node.
    -- A representation of the world in a non graphical environment.
    ask(Nodes, function(x)
        -- print(x.xcor,x.ycor)
        ask(
            one_of(Patches:with( function(c) return c:xcor() == x:xcor() and c:ycor() == x:ycor() end ))
            , function(o)
            o.label = 'O'
        end)
    end)

end)


run(function()
    print_current_config()
    Config.go = false
    -- pd(Links)
end)


