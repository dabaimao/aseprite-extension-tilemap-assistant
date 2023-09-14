require("Object")
function Tile()
    local obj = Object()
    local tile = setmetatable({
        tilePos=Point(0,0)
    }, { __index = obj })
    return tile
end