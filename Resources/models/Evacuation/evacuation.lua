require 'Engine.utilities.utl_main'
local cs = require 'Resources.models.Evacuation.files.create_scenario'
local fs = require 'Resources.models.Evacuation.files.fuzzy_sets'
local iw = require 'Resources.models.Evacuation.files.interface_windows'



-------------------------------------
------  Model Global variables ------
-------------------------------------
local global_vars = {
    app_not_alerted     = 0,
    app_accident        = 0,
    app_killed          = 0,
    app_rescued         = 0,
    app_secure_room     = 0,
    not_app_not_alerted = 0,
    not_app_accident    = 0,
    not_app_killed      = 0,
    not_app_rescued     = 0,
    not_app_secure_room = 0,
    total_not_alerted   = 0,
    total_accident      = 0,
    total_killed        = 0,
    total_rescued       = 0,
    total_secure_room   = 0
}

-- This method will create the interface params (See interface_window.lua).
local get = iw.create_interface()

-- A map "id -> internal_id". It will be populated by the "create_scenario function"
local id_map = {}




-------------------------------------
--------------  SETUP  --------------
-------------------------------------

SETUP = function()

    -- Reset the simulation
    Simulation:reset()

    declare_FamilyCell('Nodes')
    declare_FamilyRel('Visibs')
    declare_FamilyRel('Transits')
    declare_FamilyRel('Sounds')
    declare_FamilyMobile('Violents')
    declare_FamilyMobile('Peacefuls')
    Nodes.z_order, Peacefuls.z_order, Violents.z_order = 3,4,5

    -- It is possible to use code of other files. This function populates "id_map" and Nodes family
    cs.create_scenario(id_map)

    for i=1,get.num_peace() do

        local lead = math.random() < get.leaders_perc()
        local a_node = one_of(Nodes:with( function(x) return x.capacity > x.residents end ) )
        a_node.residents = a_node.residents + 1
        Peacefuls:new({
            attacker_heard      = 0,
            attacker_sighted    = 0,
            fire_heard          = 0,
            fire_sighted        = 0,
            bomb_heard          = 0,
            bomb_sighted        = 0,
            scream_heard        = 0,
            corpse_sighted      = 0,
            police_sighted      = 0,
            leader_sighted      = 0,
            running_people      = 0,
            percived_risk       = 0,
            p_timer             = 0,
            fear                = 0,
            pos                 = copy(a_node.pos),
            shape               = 'person',
            color               = lead and {0,1,0,1} or {1,1,1,1},
            app                 = math.random() < get.app_perc() and true or false,
            sensibility         = gaussian( get.sensib_med(), get.sensib_dev() ) * 100,
            leadership          = lead and math.random() + 0.1 or 0,
            in_panic            = false,
            hidden              = false,
            last_locations      = {a_node},
            location            = a_node,
            next_location       = a_node,
            route               = {},
            base_speed          = get.n_a_speed(),
            speed               = get.n_a_speed(),
            state               = 'not alerted',
            in_a_secure_room    = false,
            bad_area            = nil

        }):lt(math.pi/2)
    end


    for i=1, get.num_violents() do

        local a_node = one_of(Nodes:with( function(x) return x.capacity > x.residents end ) )
        a_node.residents = a_node.residents + 1

        Violents:new({
            pos             = copy(a_node.pos ),
            location        = a_node,
            next_location   = a_node,
            scale           = 1.5,
            shape           = 'person',
            color           = {1,0,0,1},
            efectivity      = get.success_rate(),
            speed           = get.attacker_speed(),
            detected        = 0,
            route           = {},
            last_locations  = {a_node}

        }):lt(math.pi/2)
    end

end





-------------------------------------
--------------  SETUP  --------------
-------------------------------------

STEP = function()
    for _,p in shuffled(Peacefuls)do
        local dist = p:dist_euc_to(p.next_location)
        if dist < 0.7 then
            local neighs = p.next_location.neighbors

            local choosen = one_of(neighs)
            p:face(choosen)
            p.location = Nodes:get(p.next_location.__id)
            p.next_location = choosen
            p.label = choosen.__id
            p.show_label = true

        else
            p:fd(1)
        end
    end

    -- for k,v in next, global_vars do
    --     print(k,v)
    -- end
end



