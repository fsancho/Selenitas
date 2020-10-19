--[[
    An example of growing and cloning of agents.

    It uses customized methods for families and several standard methods
    (die, clone) and agent properties (alive)
]]

-----------------
-- Interface 
-----------------
Interface:create_slider('N_agents', 0, 10, 1, 3)
Interface:create_slider('Max_age', 5, 100, 1, 50)
Interface:create_slider('Clone_probability', 0, 100, 1, 20)

----------------------
-- Auxiliary Functions
----------------------

function Agents_methods()
    -- Customized Method: The agent get older, and dies when it reachs the max 
    -- age. Died agents have a 'alive = false', but they still remain in the world until 
    -- a purge is performed. 
    -- 'purge_agents()'  at the end of the 'step' block will delete them from the world.
    Agents:add_method('grow_old', function(agent)
        agent.age = agent.age + 1
        agent.scale = agent.age / 10
-- <<<<<<< HEAD:Resources/examples/GrowAndClone.lua
--         if agent.age > Interface.Max_age then
-- =======
        if agent.age > Interface:get_value("Max_age") then
-- >>>>>>> dev:Resources/examples/Hatch.lua
            die(agent)
        end
        -- Always a method must return the self agent in order to concatenate methods
        return agent
    end)

    -- New method for Agents family: relocate agents as they are living in a torus
    Agents:add_method('pos_to_torus', function(self, minsize_x, maxsize_x, minsize_y, maxsize_y)
        -- Current position of agent
        local x,y = self:xcor(),self:ycor()
        -- Change coordinates to restrict inside the torus
        if x > maxsize_x then
            self.pos[1] =  minsize_x + (x - maxsize_x)
        elseif x < minsize_x then
            self.pos[1] = maxsize_x - (minsize_x - x)
        end
        if y > maxsize_y then
            self.pos[2] =  minsize_y + (y - maxsize_y)
        elseif y < minsize_y then
            self.pos[2] = maxsize_y - (minsize_y - y)
        end
        -- Always a method must return the self agent in order to concatenate methods
        return self
    end)

    -- Agents have a chance to clone itself in each iteration
    Agents:add_method('reproduce', function(agent)
        if agent.alive then
-- <<<<<<< HEAD:Resources/examples/GrowAndClone.lua
--             -- By default, Lua can't compare tables by value
--             if same_rgb(agent, {1,0,0,1}) and math.random(100) <= Interface.Clone_probability then
--                 -- Clone agent and provide some changes to new agent
-- =======
            if same_rgb(agent, {1,0,0,1}) and math.random(100) <= Interface:get_value("Clone_probability") then
-- >>>>>>> dev:Resources/examples/Hatch.lua
                Agents:clone_n(1, agent, function(x)
                    x.color = math.random(10) > 1 and {0,0,1,1} or {1,0,0,1} -- If math.random(10) > 1 then {0,0,1,1} else {1,0,0,1} 
                    x.age   = 0
                end)
            end
        end
    end)
end

-----------------
-- Setup Function
-----------------

SETUP = function()

    -- clear('all')
    Simulation:reset()

    -- Create a Family of Mobil agents
    declare_FamilyMobile('Agents')

    -- Add new methods to Agents
    Agents_methods()

    -- Populate the Family with 3 agents. Each agent will have the parameters
    -- specified in the table (and some parameters obteined just for be a Mobil instance)
-- <<<<<<< HEAD:Resources/examples/GrowAndClone.lua
--     for i=1,Interface.N_agents do
-- =======
    for i=1,Interface:get_value("N_agents") do
-- >>>>>>> dev:Resources/examples/Hatch.lua
        Agents:new({
            ['pos']     = {math.random(-50,50),math.random(-50,50)}
            ,['head']    = math.random(2*math.pi)
            ,['age']     = 0
            ,['color']   = {1,0,0,1}
        })
    end
end

-----------------
-- Step Function
-----------------

STEP = function()

    -- A stop condition. We stop when the number of ticks is reached or when there are no agents alive
    if Agents.count == 0 then
        Simulation:stop()
    end

    for _,agent in shuffled(Agents) do
        agent
        :lt(math.random(-0.5,0.5))
        :fd(0.8)
        :pos_to_torus(-50,50,-50,50)
        :grow_old()
        :reproduce()
    end

    -- Killed agents are purged of the simulation
    purge_agents(Agents)
end