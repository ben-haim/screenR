
if !exists("g:screenR_rh")
    let g:screenR_height = 15
endif

function! StartR(whatr)
    if string(g:SendCmdToR) != "function('SendCmdToR_fake')"
        return
    endif
    let slog = system('screen -X eval "split" "focus down" "resize ' . 
                \ g:screenR_height . '" "screen -t RConsole" ')
    let slog = system("screen -p RConsole -X stuff '" .
                \ "VIMRPLUGIN_TMPDIR=" . $VIMRPLUGIN_TMPDIR . 
                \ " VIMRPLUGIN_HOME=" . $VIMRPLUGIN_HOME . 
                \ " VIMINSTANCEID=" . $VIMINSTANCEID . 
                \ " VIMEDITOR_SVRNM=" . $VIMEDITOR_SVRNM . " R'\<c-m>")
    let g:SendCmdToR = function('SendCmdToR_GNUScreen')
endfunction

function! SendCmdToR_GNUScreen(cmd)
    if g:vimrplugin_ca_ck
        let cmd = "\001" . "\013" . a:cmd
    else
        let cmd = a:cmd
    endif

    let str = substitute(cmd, "'", "'\\\\''", "g")
    let scmd = "screen -p RConsole -X stuff '" . str . "\<C-M>'"
    let rlog = system(scmd)
    if v:shell_error
        let rlog = substitute(rlog, "\n", " ", "g")
        let rlog = substitute(rlog, "\r", " ", "g")
        call RWarningMsg(rlog)
        let g:SendCmdToR = function('SendCmdToR_fake')
        return 0
    endif
    return 1
endfunction

