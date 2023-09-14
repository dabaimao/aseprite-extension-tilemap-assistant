
DlgDecisionDelete=Dialog{title="Warnning",notitlebar=true}
DlgDecisionDelete:label{
    id="lb_delete_message",
    text="Are you sure delete the tilemap palette."
}

DlgDecisionDelete:button{
    id="btn_delete_confirm",
    text="Confirm",
    onclick=function (ev)
        RemoveSpecFile(DataTilemapsDirFullPath..Sep..DlgMainWindow.data.cbox_main_palettes.."."..ExtensionName)
        PaletteList=GetDocumentFiles(DataTilemapsDirFullPath,ExtensionName)
        DlgMainWindow:modify{id="cbox_main_palettes",options=PaletteList}
        if #PaletteList<=0 then
            DlgMainWindow:modify{id="btn_main_reset",enabled=false}
        end
        DlgMainWindow:repaint()
        DlgDecisionDelete:close()
    end
}
DlgDecisionDelete:button{
    id="btn_delete_cancel",
    text="Cancel",
    onclick=function (ev)
        DlgDecisionDelete:close()
    end
}