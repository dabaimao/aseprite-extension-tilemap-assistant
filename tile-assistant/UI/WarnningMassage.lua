
DlgWarnning=Dialog { title = "Warnning Message", notitlebar = true }

DlgWarnning:label { id = "lb_warnning_message", label = "Warnning:", text = "" }

DlgWarnning:button { id = "btn_warnning_ok", text = "Ok",
    function()
        DlgWarnning:close()
        DlgWarnning:modify{id="lb_warnning_message",text=""}
    end
}