
function TilemapCanvas()
    local obj = Object()
    local canvas = setmetatable({
        grid=Grid(),
        selectedTile=Point(0,0),
        isEraser=false
    }, { __index = obj })

    function canvas:getTilePosition(mousePos)
        local sprPos=self:screenPosToObjPos(mousePos)
        local hoverCell=Point(0,0)
        hoverCell.x=sprPos.x/self.grid.cell.x+1
        hoverCell.y=sprPos.y/self.grid.cell.y+1
        return hoverCell
    end

    function canvas:setTilePos(tile,mousePos)
        local sprPos=self:screenPosToObjPos(mousePos)
        local selectedCell=Point(0,0)
        selectedCell.x=sprPos.x-sprPos.x%self.grid.cell.x
        selectedCell.y=sprPos.y-sprPos.y%self.grid.cell.y


        local st=Point(0,0)
        st.x=selectedCell.x/self.grid.cell.x
        st.y=selectedCell.y/self.grid.cell.y

        if st~=self.selectedTile then
            if self.isEraser then
                local bounds=Rectangle(0,0,0,0)
                bounds.origin=selectedCell
                bounds.width=self.grid.cell.x
                bounds.height =self.grid.cell.y
                self.spr:clear(bounds)
            else
                self.spr:drawImage(tile,selectedCell)
            end
        end

        self.selectedTile=st
    end
    return canvas
end