DlgCreateNew = Dialog { title = "New Tilemap", notitlebar = true }

local createPreviewSize = Rectangle(0, 0, 128, 128)
local createPreviewBgColor = { r = 0, g = 0, b = 0, a = 255 }
local createPreviewGridColor = { r = 0, g = 186, b = 186, a = 255 }
local createPreviewFrameColor = { r = 80, g = 80, b = 80, a = 255 }

local newTilemapPalette = TilemapPalette()
local previewTilemapPalette=TilemapPalette()
local function entryData(entId)
    local num = InputNumLimitDown(tonumber(DlgCreateNew.data[entId]), 1)
    num = math.floor(num)
    DlgCreateNew:modify { id = entId, text = tonumber(num) }
    return num
end

DlgCreateNew:entry {
    id = "ent_new_name",
    label = "Name:",
    text = "newtilemap",
}
-- Cell
DlgCreateNew:label {
    id = "lb_cell",
    text = "Cell",
    visible = false,
}

DlgCreateNew:entry {
    id = "ent_new_cell_x",
    label = "X:",
    text = "64",
    onchange = function()
        newTilemapPalette.grid.cell.x = entryData("ent_new_cell_x")
        previewTilemapPalette.grid.cell.x=entryData("ent_new_cell_x")
        DlgCreateNew:repaint()
    end
}
DlgCreateNew:entry {
    id = "ent_new_cell_y",
    label = "Y:",
    text = "64",
    onchange = function()
        newTilemapPalette.grid.cell.y = entryData("ent_new_cell_y")
        previewTilemapPalette.grid.cell.y=entryData("ent_new_cell_y")
        DlgCreateNew:repaint()
    end
}
DlgCreateNew:check { id = "chk_new_moredata",
    label = "Advance Data",
    text = "Enable",
    selected = false,
    onclick = function()
        if DlgCreateNew.data.chk_new_moredata then
            DlgCreateNew:modify { id = "ent_new_gap_x", enabled = true }
            DlgCreateNew:modify { id = "ent_new_gap_y", enabled = true }
            DlgCreateNew:modify { id = "ent_new_offset_x", enabled = true }
            DlgCreateNew:modify { id = "ent_new_offset_y", enabled = true }

            DlgCreateNew:modify { id = "lb_gap", visible = true }
            DlgCreateNew:modify { id = "ent_new_gap_x", visible = true }
            DlgCreateNew:modify { id = "ent_new_gap_y", visible = true }

            DlgCreateNew:modify { id = "lb_offset", visible = true }
            DlgCreateNew:modify { id = "ent_new_offset_x", visible = true }
            DlgCreateNew:modify { id = "ent_new_offset_y", visible = true }
        else
            DlgCreateNew:modify { id = "ent_new_gap_x", enabled = false }
            DlgCreateNew:modify { id = "ent_new_gap_y", enabled = false }
            DlgCreateNew:modify { id = "ent_new_offset_x", enabled = false }
            DlgCreateNew:modify { id = "ent_new_offset_y", enabled = false }

            DlgCreateNew:modify { id = "lb_gap", visible = false }
            DlgCreateNew:modify { id = "ent_new_gap_x", visible = false }
            DlgCreateNew:modify { id = "ent_new_gap_y", visible = false }

            DlgCreateNew:modify { id = "lb_offset", visible = false }
            DlgCreateNew:modify { id = "ent_new_offset_x", visible = false }
            DlgCreateNew:modify { id = "ent_new_offset_y", visible = false }
        end
    end
}
-- Gap
DlgCreateNew:label {
    id = "lb_gap",
    text = "Gap",
    visible = false,
}

DlgCreateNew:entry {
    id = "ent_new_gap_x",
    label = "X:",
    text = "0",
    enabled = false,
    visible = false,
    onchange = function()
        newTilemapPalette.grid.gap.x = entryData("ent_new_gap_x")
        previewTilemapPalette.grid.gap.x=entryData("ent_new_gap_x")
        DlgCreateNew:repaint()
    end
}

DlgCreateNew:entry {
    id = "ent_new_gap_y",
    label = "Y:",
    text = "0",
    enabled = false,
    visible = false,
    onchange = function()
        newTilemapPalette.grid.gap.y = entryData("ent_new_gap_y")
        previewTilemapPalette.grid.gap.y=entryData("ent_new_gap_y")
        DlgCreateNew:repaint()
    end
}

-- offset
DlgCreateNew:label {
    id = "lb_offset",
    text = "Offset",
    visible = false,
}

DlgCreateNew:entry {
    id = "ent_new_offset_x",
    label = "X:",
    text = "0",
    enabled = false,
    visible = false,
    onchange = function()
        newTilemapPalette.grid.offset.x = entryData("ent_new_offset_x")
        previewTilemapPalette.grid.offset.x = entryData("ent_new_offset_x")
        DlgCreateNew:repaint()
    end
}

DlgCreateNew:entry {
    id = "ent_new_offset_y",
    label = "Y:",
    text = "0",
    enabled = false,
    visible = false,
    onchange = function()
        newTilemapPalette.grid.offset.y = entryData("ent_new_offset_y")
        previewTilemapPalette.grid.offset.y = entryData("ent_new_offset_y")
        DlgCreateNew:repaint()
    end
}

DlgCreateNew:canvas {
    id = "canvas_create_preview",
    width = createPreviewSize.width,
    height = createPreviewSize.height,
    onpaint = function(ev)
        local gc = ev.context
        DrawBounds(gc, createPreviewSize, createPreviewBgColor)

        if app.image~=nil  then
            previewTilemapPalette=previewTilemapPalette:imageIntoTilePalette(app.image)
            previewTilemapPalette.bounds=ImageAdaptationScreen(previewTilemapPalette.bounds,createPreviewSize)
            gc:drawImage(previewTilemapPalette.spr, previewTilemapPalette.spr.bounds, previewTilemapPalette.bounds)
        end

        DrawPaletteGridLine(gc,createPreviewGridColor,createPreviewSize,previewTilemapPalette)

        DrawFrame(gc, createPreviewSize, createPreviewFrameColor)
    end
}

-- Create Button
DlgCreateNew:button {
    id = "btn_new_create",
    text = "Create",
    onclick = function()
        if app.image ~= nil then
            if SameNameFilesCheck(PaletteList, DlgCreateNew.data.ent_new_name) then
                DlgWarnning:modify { id = "lb_warnning_message", text = "This file of name already exist." }
                DlgWarnning:show { wait = true }
            else
                newTilemapPalette = newTilemapPalette:imageIntoTilePalette(app.image)
                newTilemapPalette.bounds = ImageAdaptationScreen(newTilemapPalette.bounds, PaletteCanvasSize)
                SetFileStream(DataTilemapsDirFullPath .. Sep .. DlgCreateNew.data.ent_new_name .. "." .. ExtensionName,
                    newTilemapPalette:serializeTilePalette())

                PaletteList[#PaletteList + 1] = DlgCreateNew.data.ent_new_name

                CurrentTilePalette = newTilemapPalette:copy()
                newTilemapPalette=TilemapPalette()

                previewTilemapPalette=TilemapPalette()

                DlgMainWindow:modify { id = "cbox_main_palettes", options = PaletteList, option = DlgCreateNew.data
                .ent_new_name }
                collectgarbage("collect")
                CurrentEditorSprite.grid=CurrentTilePalette.grid
                DlgEditeCanvas:repaint()
                DlgMainWindow:repaint()
                DlgCreateNew:close()
            end
        else
            DlgWarnning:modify { id = "lb_warnning_message", text = "Please open a image file" }
            DlgWarnning:show { wait = true }
        end
    end
}
-- Cancel Button
DlgCreateNew:button {
    id = "btn_new_cancel",
    text = "Cancel",
    onclick = function()
        newTilemapPalette = TilemapPalette()
        DlgCreateNew:close()
    end
}
