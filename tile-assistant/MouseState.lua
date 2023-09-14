
function MouseState()
    local state={
        pos=Point(0,0),
        holdPos=Point(-99,-99),
        zoomPos=Point(0,0),
        hoverPos=Point(0,0),
        leftDown=false,
        rightDown=false,
        wheelDown=false,
    }
    return state
end