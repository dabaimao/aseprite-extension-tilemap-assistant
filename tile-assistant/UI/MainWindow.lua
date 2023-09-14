PaletteList = {}
--============================================================================
-- Palette Canvas Property Data
--============================================================================
PaletteCanvasSize = Rectangle(0, 0, 255, 255)
PaletteCanvasBgColor = { r = 125, g = 125, b = 125, a = 255 }
PaletteCanvasFrameColor = { r = 255, g = 0, b = 0, a = 255 }

PaletteGridColor = { r = 255, g = 0, b = 255, a = 255 }
PaletteSelectedCellColor = { r = 0, g = 255, b = 0, a = 255 }
PaletteHoverCellColor = { r = 0, g = 255, b = 255, a = 255 }
PaletteCanvasCVColor={r = 86, g = 86, b = 86, a = 255}
--============================================================================
-- Main Window Dialog
--============================================================================
DlgMainWindow = Dialog { title = "Tilemap Assistant" }

DlgMainWindow:button {
    id = "btn_main_setting",
    text = "Setting",
    enabled=false,
    visible=false,
    onclick = function(ev)
    end
}
DlgMainWindow:button {
    id = "btn_main_modify",
    text = "Modify Palette",
    enabled=false,
    visible=false,
    onclick = function(ev)
    end
}


DlgMainWindow:newrow { always = false }
DlgMainWindow:button {
    id = "btn_main_reset",
    text = "Reset",
    enabled=true,
    onclick = function(ev)
        if #PaletteList>0 then
            CurrentTilePalette.bounds = ImageAdaptationScreen(CurrentTilePalette.spr.bounds, PaletteCanvasSize)
            DlgMainWindow:repaint()
        end
    end
}
DlgMainWindow:button {
    id = "btn_main_open",
    text = "Open Canvas",
    onclick = function(ev)
        if app.sprite~=nil then
            CurrentEditorSprite = TilemapCanvas()
            CurrentEditorSprite.spr=app.image
            CurrentEditorSprite.bounds = ImageAdaptationScreen(CurrentEditorSprite.spr.bounds, EditeCanvasSize)
            CurrentEditorSprite.grid=CurrentTilePalette.grid

            local b=DlgEditeCanvas.bounds
            b.x=DlgMainWindow.bounds.x+DlgMainWindow.bounds.width+20
            DlgEditeCanvas.bounds=b

            DlgEditeCanvas:show { wait = false }
            DlgEditeCanvas:repaint()
        end
    end
}
DlgMainWindow:newrow { always = false }

-- Tilemap Palette Canvas
DlgMainWindow:canvas {
    id = "canvas_main_palette",
    width = PaletteCanvasSize.width,
    height = PaletteCanvasSize.height,
    onpaint = function(ev)
        local gc = ev.context
        --1 Draw Background
        DrawBounds(gc, PaletteCanvasSize, PaletteCanvasBgColor)
        DrawBounds(gc,CurrentTilePalette.bounds,EditeCanvasCVColor)

        if #PaletteList > 0 then
        --2 Draw Palette
            gc:drawImage(CurrentTilePalette.spr, CurrentTilePalette.spr.bounds, CurrentTilePalette.bounds)

        --3 Draw Grid
             local start=DrawPaletteGridLine(gc, PaletteGridColor, PaletteCanvasSize, CurrentTilePalette)

        --4 Draw Selected Cell
        if TileBrush~=nil then
            DrawHightLightSelectedCell(gc,PaletteSelectedCellColor,start,CurrentTilePalette)
        end

        --5 Draw Hover Cell
            DrawHightLightHoverCell(gc,PaletteHoverCellColor,start,MouseData.hoverPos)
        end

        --6 Draw Frame

        DrawFrame(gc, PaletteCanvasSize, PaletteCanvasFrameColor)
    end,

    onmousemove = function(ev)
        MouseData.hoverPos=Point(ev.x,ev.y)
        if MouseData.leftDown then
            -- Move Camera
            CurrentTilePalette:move(Point(ev.x, ev.y) + MouseData.holdPos)
            DlgMainWindow:modify{ id="canvas_main_palette", mouseCursor=MouseCursor.MOVE}
        end
        DlgMainWindow:repaint()
    end,

    onmousedown = function(ev)
        if ev.button == MouseButton.RIGHT then
            -- Get Mouse Hold Palette Point
            MouseData.leftDown = true
            MouseData.holdPos = CurrentTilePalette.bounds.origin - Point(ev.x, ev.y)
        elseif ev.button == MouseButton.LEFT then
            TileBrush=CurrentTilePalette:getTile(Point(ev.x,ev.y))
            DlgMainWindow:repaint()
        end
    end
    ,
    onmouseup=function (ev)
        MouseData.hoverPos=Point(ev.x,ev.y)
        if ev.button == MouseButton.RIGHT then
            MouseData.leftDown = false
            DlgMainWindow:modify{ id="canvas_main_palette", mouseCursor=MouseCursor.ARROW}
        end
    end,
    onwheel=function (ev)
        MouseData.hoverPos=Point(ev.x,ev.y)
        if MouseData.zoomPos~=Point(ev.x,ev.y) then
            MouseData.zoomPos=Point(ev.x,ev.y)
        end
        if ev.deltaY ~= 0 then

        -- Camera Zoom
            CurrentTilePalette:zoom(ev.deltaY*10)
            DlgMainWindow:repaint()
        end
    end

}

-- Tilemap selectable list
DlgMainWindow:combobox {
    id = "cbox_main_palettes",
    --label="selected",
    options = {},
    option = "",
    onchange = function()
        if #PaletteList > 0 and app.image~=nil then
            CurrentTilePalette = CurrentTilePalette:unserializeTilePalette(GetFileStream(DataTilemapsDirFullPath ..
                Sep .. DlgMainWindow.data.cbox_main_palettes .. "." .. ExtensionName))
            --DlgMainWindow:modify{id="btn_main_reset",enabled=true}
            if CurrentEditorSprite~=nil then
                CurrentEditorSprite.grid=CurrentTilePalette.grid
            end
            DlgEditeCanvas:repaint()
        else
            --DlgMainWindow:modify{id="btn_main_reset",enabled=false}
        end
        TileBrush=nil
        DlgMainWindow:repaint()
    end
}
-- Button Add A New Tile Palette
DlgMainWindow:button {
    id = "btn_main_add",
    text = "Add",
    onclick = function(ev)
        if app.image ~= nil then
            DlgCreateNew:show { wait = true }
        else
            DlgWarnning:modify { id = "lb_warnning_message", text = "Please Open A Image File." }
            DlgWarnning:show { wait = true }
        end
    end
}

-- Button "Remove" ,Remove current selected tilemap file

DlgMainWindow:button {
    id = "btn_main_remove",
    text = "Remove",
    onclick = function(ev)
        if #PaletteList > 0 then
            DlgDecisionDelete:show { wait = true }
        end
    end
}

