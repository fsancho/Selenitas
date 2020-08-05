

local utl_sf = {}

-- ======================================= --
-- FUNCTIONS FOR READING FILES AND STRINGS --
-- ======================================= --

-- This function checks if a file exists
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- Each line in a file will be added to a table, this function returns the table with all lines in a file
function utl_sf.lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
      lines[#lines + 1] = line
    end
    return lines
end

-- Split a string ("pString") using "pPattern" as splitter. eg: split("hello,world!", ",") -> {"hello" , "world!"}
function utl_sf.split(pString, pPattern)
    local Table = {}
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
        table.insert(Table,cap)
        end
        last_end = e+1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end
--------------------------


-- ==================== --
-- UTILITIES FOR LISTS  --
-- ==================== --

-- This function returns the first n elements of a list
function utl_sf.first_n(n,list)
    local res = {}
    if n >= #list then
        return list
    else
        for i=1,n do
            res[i] = list[i]
        end
    end
    return res
end


-- This function returns the last n elements of a list
function utl_sf.last_n(n,list)
    local res = {}
    if n >= #list then
        return list
    else
        for i = #list-(n-1) , #list do
            res[#res+1] = list[i]
        end
    end
    return res
end



return utl_sf