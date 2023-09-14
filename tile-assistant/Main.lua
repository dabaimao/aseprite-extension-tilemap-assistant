require("FileSystem")
require("MathTool")
require("Object")
require("Constant")
require("Graphics")
require("MouseState")
require("KeyState")
require("Grid")
require("TilemapPalette")
require("TilemapCanvas")
require("PublicVariable")

require('UI.MainWindow')
require('UI.CreateNew')
require('UI.WarnningMassage')
require('UI.EditeCanvas')
require('UI.DecisionDelete')

function init(plugin)
    plugin:newCommand {
        id = "tile_assistant_command",
        title = "Tile Assistant",
        group = "layer_properties",

        onclick = function()
            --Directiory Path Check
            if not app.fs.isDirectory(DataDirectioryNameFullPath) then
                app.fs.makeAllDirectories(DataTilemapsDirFullPath)
            end

            PaletteList = GetDocumentFiles(DataTilemapsDirFullPath, ExtensionName)

            DlgMainWindow:modify { id = "cbox_main_palettes", options = PaletteList }

            if #PaletteList > 0 then
                local s = GetFileStream(DataTilemapsDirFullPath ..
                Sep .. DlgMainWindow.data.cbox_main_palettes .. "." .. ExtensionName)
                CurrentTilePalette = TilemapPalette()
                CurrentTilePalette = CurrentTilePalette:unserializeTilePalette(s)
                DlgMainWindow:modify { id = "btn_main_reset", enabled = true }
            else
                DlgMainWindow:modify { id = "btn_main_reset", enabled = false }
            end


            app.events:on('sitechange',
                function(ev)
                    if app.sprite ~= nil then
                        CurrentEditorSprite = TilemapCanvas()
                        CurrentEditorSprite.spr = app.image
                        --CurrentEditorSprite.grid=CurrentTilePalette.grid
                        CurrentEditorSprite.bounds = ImageAdaptationScreen(CurrentEditorSprite.spr.bounds,
                            EditeCanvasSize)
                    else
                    end
                    DlgEditeCanvas:repaint()
                end
            )
            app.events:on('beforecommand',
                function(ev)
                    if ev.name == "Undo" then
                        DlgEditeCanvas:repaint()
                    end
                end)


            DlgMainWindow:show { wait = false }
        end,
        onenabled = function()
            if app.sprite ~= nil then
                return true
            else
                return false
            end
        end
    }
end
