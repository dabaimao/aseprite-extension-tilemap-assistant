--==================================================================================
--Edite Canvas Property Data
--==================================================================================
-- Window Size
EditeCanvasSize = Rectangle(0, 0, 384, 384)

EditeCanvasBgColor = Color { r = 128, g = 128, b = 128, a = 255 }
EditeCanvasCVColor = Color { r = 86, g = 86, b = 86, a = 255 }
EditeCanvasGridColor = Color { r = 0, g = 0, b = 155, a = 255 }
EditeCanvasFrameColor = Color { r = 0, g = 220, b = 255, a = 255 }
EditeCanvasHoverColor = Color { r = 220, g = 220, b = 255, a = 255 }

BrushCache = Image()

local function drawTile()
    if (app.image ~= nil and TileBrush ~= nil)or CurrentEditorSprite.isEraser  then
        CurrentEditorSprite:setTilePos(TileBrush, MouseData.hoverPos)
        app.refresh()
    end
end
--##################################################################################
-- Draw Canvas Window
--##################################################################################

DlgEditeCanvas = Dialog { title = "Tile Draw Canvas", parent = DlgMainWindow }


DlgEditeCanvas:canvas {
    id = "canvas_editor",
    width = EditeCanvasSize.width,
    height = EditeCanvasSize.height,
    onpaint = function(ev)
        local gc = ev.context

        DrawBounds(gc, EditeCanvasSize, EditeCanvasBgColor)

        if app.image ~= nil then
            DrawBounds(gc, CurrentEditorSprite.bounds, EditeCanvasCVColor)

            gc:drawImage(CurrentEditorSprite.spr, CurrentEditorSprite.spr.bounds,
                CurrentEditorSprite.bounds)


            local start = DrawPaletteGridLine(gc, EditeCanvasGridColor, EditeCanvasSize, CurrentEditorSprite)

            if TileBrush ~= nil then
                TileBrushHover(gc, TileBrush, start, MouseData.hoverPos)
            else
                DrawHightLightHoverCell(gc, PaletteHoverCellColor, start, MouseData.hoverPos)
            end
        end


        DrawFrame(gc, EditeCanvasSize, EditeCanvasFrameColor)
    end,

    onmousemove = function(ev)
        MouseData.hoverPos = Point(ev.x, ev.y)
        if MouseData.rightDown then
            -- Move Camera
            CurrentEditorSprite:move(Point(ev.x, ev.y) + MouseData.holdPos)
            DlgEditeCanvas:modify { id = "canvas_editor", mouseCursor = MouseCursor.MOVE }
        elseif MouseData.leftDown then
            drawTile()
        end
        local tilePos = CurrentEditorSprite:getTilePosition(MouseData.hoverPos)
        DlgEditeCanvas:modify { id = "lb_canvas_tileposition", text = "Tile Position: " .. tilePos.x .. "," .. tilePos.y }
        DlgEditeCanvas:repaint()
    end,
    onmousedown = function(ev)
        if ev.button == MouseButton.RIGHT then
            -- Get Mouse Hold Palette Point
            MouseData.rightDown = true
            MouseData.holdPos = CurrentEditorSprite.bounds.origin - Point(ev.x, ev.y)
        elseif ev.button == MouseButton.LEFT then
            MouseData.leftDown = true
        end
    end,
    onmouseup = function(ev)
        MouseData.hoverPos = Point(ev.x, ev.y)
        if ev.button == MouseButton.RIGHT then
            MouseData.rightDown = false
            DlgMainWindow:modify { id = "canvas_main_palette", mouseCursor = MouseCursor.ARROW }
        elseif ev.button == MouseButton.LEFT then
            MouseData.leftDown = false
            drawTile()
        end
    end,
    onwheel = function(ev)
        MouseData.hoverPos = Point(ev.x, ev.y)
        if MouseData.zoomPos ~= Point(ev.x, ev.y) then
            MouseData.zoomPos = Point(ev.x, ev.y)
        end
        if ev.deltaY ~= 0 then
            CurrentEditorSprite:zoom(ev.deltaY * 10)
            DlgEditeCanvas:repaint()
        end
    end,
}


DlgEditeCanvas:button { id = "btn_canvas_clear", text = "Erase",
    onclick = function()
        if app.image ~= nil then
            CurrentEditorSprite.isEraser = true
        end
    end
}
DlgEditeCanvas:button { id = "btn_canvas_paint", text = "Paint",
    onclick = function()
        if app.image ~= nil then
            CurrentEditorSprite.isEraser = false
        end
    end
}
DlgEditeCanvas:label { id = "lb_canvas_tileposition", text = "Tile Position: 0,0" }
