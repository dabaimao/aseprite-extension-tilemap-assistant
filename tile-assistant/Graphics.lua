function TilemapGridSizeCalclation(size, grid)
    local pX = (-size.width) % (grid.cell.x + grid.gap.x)
    local pY = (-size.height) % (grid.cell.y + grid.gap.y)

    local g = Point(0, 0)

    g.x = size.width + pX
    g.y = size.height + pY


    return g
end

function DrawFrame(gc, rect, color)
    gc.color = color
    gc:fillRect(Rectangle(rect.x, rect.y, rect.width, 1))
    gc:fillRect(Rectangle(rect.x, rect.y + rect.height - 1, rect.width, 1))
    gc:fillRect(Rectangle(rect.x, rect.y, 1, rect.height))
    gc:fillRect(Rectangle(rect.x + rect.width - 1, rect.y, 1, rect.height))
end

function DrawBounds(gc, rect, color)
    gc.color = color
    gc:fillRect(Rectangle(rect.x, rect.y, rect.width, rect.height))
end

function ImageAdaptationScreen(bounds, specBounds)
    local ratioB = bounds.width / bounds.height
    local ratioSB = specBounds.width / specBounds.height
    if ratioB > ratioSB then
        bounds.width = specBounds.width
        bounds.height = bounds.width / ratioB
        local chRel = specBounds.height / 2 - bounds.height / 2
        bounds.y = bounds.y + chRel
    else
        bounds.height = specBounds.height
        bounds.width = bounds.height * ratioB
        local cwRel = specBounds.width / 2 - bounds.width / 2
        bounds.x = bounds.x + cwRel
    end


    return bounds
end

-- Draw Grid Line
function DrawPaletteGridLine(gc, color, scSize, obj)
    gc.color = color

    local objRelSize = { x = obj.spr.width / obj.bounds.width, y = obj.spr.height / obj.bounds.height }

    local cellPoint = {
        x = objRelSize.x * obj.bounds.x % obj.grid.cell.x,
        y = objRelSize.y * obj.bounds.y % obj.grid.cell.y
    }

    local start = {
        x = cellPoint.x / objRelSize.x,
        y = cellPoint.y / objRelSize.y,
        cellX = obj.grid.cell.x * obj.bounds.width / obj.spr.width,
        cellY = obj.grid.cell.y * obj.bounds.height / obj.spr.height
    }

    if obj.grid.gap.x == 0 then
        local drawPoint = 0
        while drawPoint < scSize.width do
            drawPoint = cellPoint.x / objRelSize.x
            gc:fillRect(Rectangle(drawPoint, 0, 1, scSize.height))
            cellPoint.x = cellPoint.x + obj.grid.cell.x
        end
    end
    if obj.grid.gap.y == 0 then
        local drawPoint = 0
        while drawPoint < scSize.height do
            drawPoint = cellPoint.y / objRelSize.y
            gc:fillRect(Rectangle(0, drawPoint, scSize.width, 1))
            cellPoint.y = cellPoint.y + obj.grid.cell.y
        end
    end

    return start
end

function DrawHightLightSelectedCell(gc,color,start,obj)

    gc.color=color

    local cell=Rectangle{
        x=obj.selectedCell.x*start.cellX+obj.bounds.x,
        y=obj.selectedCell.y*start.cellY+obj.bounds.y,
        width=start.cellX,
        height=start.cellY
    }

    gc:fillRect(Rectangle(cell.x, cell.y, cell.width+1, 1))
    gc:fillRect(Rectangle(cell.x, cell.y + cell.height, cell.width, 1))
    gc:fillRect(Rectangle(cell.x, cell.y, 1, cell.height))
    gc:fillRect(Rectangle(cell.x + cell.width, cell.y, 1, cell.height))

    return cell
end

function DrawHightLightHoverCell(gc, color, start, mousePos)
    gc.color = color

    local hover = {
        x = mousePos.x - (mousePos.x - start.x) % start.cellX,
        y = mousePos.y - (mousePos.y - start.y) % start.cellY,
        width = start.cellX,
        height = start.cellY
    }
    gc:fillRect(Rectangle(hover.x, hover.y, hover.width, 1))
    gc:fillRect(Rectangle(hover.x, hover.y + hover.height, hover.width, 1))
    gc:fillRect(Rectangle(hover.x, hover.y, 1, hover.height))
    gc:fillRect(Rectangle(hover.x + hover.width, hover.y, 1, hover.height))


end

function TileBrushHover(gc,tile,start,mousePos)
    local hover = Rectangle{
        x = mousePos.x - (mousePos.x - start.x) % start.cellX,
        y = mousePos.y - (mousePos.y - start.y) % start.cellY,
        width = start.cellX+1,
        height = start.cellY+1
    }
    gc:drawImage(tile,tile.bounds,hover)
end