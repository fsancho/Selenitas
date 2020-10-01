------------------
-- A class to control some parameters related with the simulation as created families, number of agents or the time.
-- @classmod
-- Simulation

local class  = require 'Thirdparty.pl.class'

local Simulation = class.Simulation()

------------------
-- TODO
-- @function _init
-- @param obj A table with some basic parameters of the Controller.
-- @return A Controller instance.
Simulation._init = function(self)
    self.seed           = os.time()
    self.is_running     = false
    self.time           = 0
    self.delta_time     = 1
    self.max_time       = 100
    self.families       = {}
    self.num_agents     = 0

    math.randomseed(self.seed)

    return self
end;

------------------
-- This function controls the ids of the agents, when a new agent is created, an unique id is given to it, this function generates new ids. This function is called by families when adding new agents.
-- @function __new_id
-- @return Number, a unique id.
-- @usage
-- -- TODO
Simulation.__new_id = function(self)
    self.num_agents = self.num_agents + 1
    return self.num_agents
end;

------------------
-- TODO
-- @function new_seed
-- @return
-- @usage
-- -- TODO
Simulation.new_seed = function(self)
    self.seed = os.clock()
    math.randomseed(self.seed)

    return self.seed
end

--=========--
-- Getters --
--=========--

------------------
-- TODO
-- @function get_seed
-- @return
-- @usage
-- -- TODO
Simulation.get_seed = function(self)
    return self.seed
end

------------------
-- TODO
-- @function get_is_running
-- @return
-- @usage
-- -- TODO
Simulation.get_is_running = function(self)
    return self.seed
end

------------------
-- TODO
-- @function get_time
-- @return
-- @usage
-- -- TODO
Simulation.get_time = function(self)
    return self.time
end

------------------
-- TODO
-- @function get_delta_time
-- @return
-- @usage
-- -- TODO
Simulation.get_delta_time = function(self)
    return self.delta_time
end

------------------
-- TODO
-- @function get_max_time
-- @return
-- @usage
-- -- TODO
Simulation.get_max_time = function(self)
    return self.max_time
end

------------------
-- TODO
-- @function get_families
-- @return
-- @usage
-- -- TODO
Simulation.get_families = function(self)
    return self.families
end

------------------
-- TODO
-- @function get_num_agents
-- @return
-- @usage
-- -- TODO
Simulation.get_num_agents = function(self)
    return self.num_agents
end

--=========--
-- Setters --
--=========--

------------------
-- This sets a seed to be used in random operations.
-- @function set_seed
-- @param num Number, the seed we want to use
-- @return Nothing.
-- @usage
-- -- TODO
Simulation.set_seed = function(self,num)
    self.seed = num
    math.randomseed = self.seed
end;

------------------
-- TODO
-- @function stop
-- @return Nothing.
-- @usage
-- -- TODO
Simulation.stop = function(self)
    self.is_running = false
end;

------------------
-- TODO
-- @function start
-- @return Nothing.
-- @usage
-- -- TODO
Simulation.start = function(self)
    self.is_running = true
end;

------------------
-- TODO
-- @function reset
-- @return Nothing.
-- @usage
-- -- TODO
Simulation.reset = function(self)
    self.is_running     = false
    self.time           = 0
    self.delta_time     = 1
    self.max_time       = 100
    self.families       = {}
    self.num_agents     = 0
end;


return Simulation