scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTIONS = {
\     'RIGHT': 0,
\     'LEFT' : 1,
\ }

function! glowshi_ft#gs_f(visualmode, vcount)
    call s:init(s:FALSE, s:DIRECTIONS.RIGHT, a:visualmode)
    call s:glowshi_ft(s:TRUE, a:vcount)
endfunction

function! glowshi_ft#gs_F(visualmode, vcount)
    call s:init(s:FALSE, s:DIRECTIONS.LEFT, a:visualmode)
    call s:glowshi_ft(s:TRUE, a:vcount)
endfunction

function! glowshi_ft#gs_t(visualmode, vcount)
    call s:init(s:TRUE, s:DIRECTIONS.RIGHT, a:visualmode)
    call s:glowshi_ft(s:TRUE, a:vcount)
endfunction

function! glowshi_ft#gs_T(visualmode, vcount)
    call s:init(s:TRUE, s:DIRECTIONS.LEFT, a:visualmode)
    call s:glowshi_ft(s:TRUE, a:vcount)
endfunction

function! glowshi_ft#gs_repeat(visualmode, vcount)
    if !exists('s:c')
        return
    endif
    call s:init(s:till_before, s:direction, a:visualmode)
    call s:glowshi_ft(s:FALSE, a:vcount)
endfunction

function! glowshi_ft#gs_opposite(visualmode, vcount)
    if !exists('s:c')
        return
    endif
    try
        let orig_direction = s:direction
        call s:init(s:till_before, !s:direction, a:visualmode)
        call s:glowshi_ft(s:FALSE, a:vcount)
    finally
        let s:direction = orig_direction
    endtry
endfunction

function! s:init(till_before, direction, visualmode)
    let s:till_before = a:till_before
    let s:direction = a:direction
    let s:visualmode = a:visualmode
    let s:mode = mode(1)
    let s:current_pos = getpos('.')
    let s:feedkey = ''
    let s:orig_ignorecase = &ignorecase
    let &ignorecase = g:glowshi_ft_ignorecase
    let s:orig_smartcase = &smartcase
    let &smartcase = g:glowshi_ft_smartcase
endfunction

function! s:glowshi_ft(getchar, vcount)
    try
        if a:getchar == s:TRUE
            echo 'char: '
            let s:c = getchar()
            if type(s:c) == type(0)
                let s:c = nr2char(s:c)
            endif
            redraw
        endif

        " cpo-;
        if a:getchar == s:FALSE && s:till_before == s:TRUE
\             && (v:version >= 704 || v:version == 703 && has("patch235")) && &cpo !~ ';'
            if s:direction == s:DIRECTIONS.RIGHT
                normal! l
            elseif s:direction == s:DIRECTIONS.LEFT
                normal! h
            endif
        endif

        let poslist = s:get_poslist()

        if len(poslist) > 0
            let pos = s:choose_pos(poslist, a:vcount)
            if type(pos) == type([])
                call s:set_default_ftFT_history()
                call s:move(pos)
                if s:feedkey != ''
                    call feedkeys(s:feedkey)
                endif
            endif
        endif
    finally
        call s:clean()
    endtry
endfunction

function! s:get_poslist()
    let poslist = []
    let flag = (s:direction == s:DIRECTIONS.LEFT) ? 'b' : ''
    while search("\\V" . s:c, flag, line('.'))
        call add(poslist, getpos('.'))
    endwhile
    call setpos('.', s:current_pos)
    return poslist
endfunction

function! s:choose_pos(poslist, default)
    if len(a:poslist) == 1
        return (a:default <= 1) ? a:poslist[0] : s:FALSE
    endif

    if s:direction == s:DIRECTIONS.RIGHT
        let selected = (a:default <= 1) ? 0 : a:default - 1
    elseif s:direction == s:DIRECTIONS.LEFT
        call reverse(a:poslist)
        let selected = (a:default <= 1) ? len(a:poslist) - 1 : len(a:poslist) - a:default
    endif

    if selected < 0 || selected > len(a:poslist) - 1
        return s:FALSE
    endif

    if a:default > 0 && g:glowshi_ft_vcount_forced_landing == s:TRUE
        return a:poslist[selected]
    endif

    let vcount = 0

    call glowshi_ft#highlight()
    let orig_cursor = s:hide_cursor()
    call s:copy_cursor(orig_cursor)
    if g:glowshi_ft_nohlsearch == s:TRUE
        nohlsearch
    endif

    echo 'char: ' . s:c

    try
        while s:TRUE
            let match_candidates = matchadd('GlowshiFtCandidates', s:regexp_candidates(a:poslist))
            let match_selected = matchadd('GlowshiFtSelected', s:regexp(a:poslist[selected]))

            redraw
            if g:glowshi_ft_timeoutlen > 0
                let c = s:getchar_with_timeout()
            else
                let c = getchar()
            endif
            if type(c) == type(0)
                let c = nr2char(c)
            endif

            call matchdelete(match_selected)
            call matchdelete(match_candidates)

            if c ==# 'h'
                let selected = (selected - ((vcount > 0) ? vcount : 1) + len(a:poslist)) % len(a:poslist)
                let vcount = 0
            elseif c ==# 'l'
                let selected = (selected + ((vcount > 0) ? vcount : 1)) % len(a:poslist)
                let vcount = 0
            elseif c == '^'
                let selected = 0
            elseif c == '$'
                let selected = len(a:poslist) - 1
            elseif c =~ '^[0-9]$'
                if vcount == 0
                    if c != '0'
                        let vcount = c
                    else
                        let selected = 0
                    endif
                else
                    let vcount .= c
                endif
            elseif c =~# g:glowshi_ft_fix_key
                break
            elseif c =~# g:glowshi_ft_cancel_key
                return s:FALSE
            else
                if c != ''
                    let s:feedkey = ((vcount > 1) ? vcount : '') . c
                endif
                break
            endif
        endwhile

        return a:poslist[selected]
    finally
        call s:show_cursor(orig_cursor)
    endtry
endfunction

function! s:regexp(pos)
    return printf('\%%%dl\%%%dc', a:pos[1], a:pos[2])
endfunction

function! s:regexp_candidates(poslist)
    let pattern = []
    for pos in a:poslist
        call add(pattern, s:regexp(pos))
    endfor
    return join(pattern, '\|')
endfunction

function! s:getchar_with_timeout()
    let start = reltime()
    let key = ''
    while s:TRUE
        let duration_sec = str2float(reltimestr(reltime(start)))
        if duration_sec * 1000 > g:glowshi_ft_timeoutlen
            break
        endif
        let key = getchar(0)
        if type(key) != 0 || key != 0
            break
        endif
        sleep 50m
    endwhile
    return key
endfunction

function! s:set_default_ftFT_history()
    if s:direction == s:DIRECTIONS.RIGHT
        if s:till_before == s:FALSE
            execute 'normal! f' . s:c
        elseif s:till_before == s:TRUE
            execute 'normal! t' . s:c
        endif
    elseif s:direction == s:DIRECTIONS.LEFT
        if s:till_before == s:FALSE
            execute 'normal! F' . s:c
        elseif s:till_before == s:TRUE
            execute 'normal! T' . s:c
        endif
    endif
    call setpos('.', s:current_pos)
endfunction

function! s:move(pos)
    let pos = a:pos[:]
    if s:till_before == s:TRUE
        if s:direction == s:DIRECTIONS.RIGHT
            let pos[2] -=1
        elseif s:direction == s:DIRECTIONS.LEFT
            let pos[2] +=1
        endif
    endif

    if s:mode == 'no'
        if s:direction == s:DIRECTIONS.LEFT
            normal! h
        endif
        normal! v
    elseif s:visualmode == s:TRUE
        normal! gv
    endif

    call setpos('.', pos)
endfunction

function! s:clean()
    if getpos('.') == s:current_pos && s:visualmode == s:TRUE
        normal! gv
    endif
    let &ignorecase = s:orig_ignorecase
    let &smartcase = s:orig_smartcase
    call s:clear_cmdline()
endfunction

function! s:clear_cmdline()
    echo
endfunction

function! s:hlexists(name)
    return strlen(a:name) > 0 && hlexists(a:name)
endfunction

function! glowshi_ft#highlight()
    if s:hlexists(g:glowshi_ft_selected_hl_link)
        let glowshi_ft_selected_hl_link = g:glowshi_ft_selected_hl_link
        if has('gui_running') && glowshi_ft_selected_hl_link ==? 'cursor'
            let glowshi_ft_selected_hl_link = 'GlowshiFtCursor'
        endif
        execute 'highlight! link GlowshiFtSelected ' . glowshi_ft_selected_hl_link
    else
        execute 'highlight GlowshiFtSelected'
\             . ' ctermfg=' . g:glowshi_ft_selected_hl_ctermfg
\             . ' guifg=' . g:glowshi_ft_selected_hl_guifg
\             . ' ctermbg=' . g:glowshi_ft_selected_hl_ctermbg
\             . ' guibg=' . g:glowshi_ft_selected_hl_guibg
    endif

    if s:hlexists(g:glowshi_ft_candidates_hl_link)
        let glowshi_ft_candidates_hl_link = g:glowshi_ft_candidates_hl_link
        if has('gui_running') && glowshi_ft_candidates_hl_link ==? 'cursor'
            let glowshi_ft_candidates_hl_link = 'GlowshiFtCursor'
        endif
        execute 'highlight! link GlowshiFtCandidates ' . glowshi_ft_candidates_hl_link
    else
        execute 'highlight GlowshiFtCandidates'
\             . ' ctermfg=' . g:glowshi_ft_candidates_hl_ctermfg
\             . ' guifg=' . g:glowshi_ft_candidates_hl_guifg
\             . ' ctermbg=' . g:glowshi_ft_candidates_hl_ctermbg
\             . ' guibg=' . g:glowshi_ft_candidates_hl_guibg
    endif
endfunction

function! s:hide_cursor()
    if has('gui_running')
        let hlid = hlID('Cursor')
        let hlid_trans = synIDtrans(hlid)
        if hlid != hlid_trans
            let orig_cursor = synIDattr(hlid_trans, 'name')
            highlight link Cursor NONE
        else
            redir => hl
            silent highlight Cursor
            redir END
            let orig_cursor = matchstr(substitute(hl, '[\r\n]', '', 'g'), 'xxx \zs.*')
            highlight Cursor NONE
        endif
    else
        let orig_cursor = &t_ve
        let &t_ve = ''
    endif
    return orig_cursor
endfunction

function! s:copy_cursor(orig_cursor)
    if has('gui_running')
        if hlexists(a:orig_cursor)
            execute 'highlight! link GlowshiFtCursor ' . a:orig_cursor
        else
            execute 'highlight GlowshiFtCursor ' . a:orig_cursor
        endif
    endif
endfunction

function! s:show_cursor(orig_cursor)
    if has('gui_running')
        if hlexists(a:orig_cursor)
            execute 'highlight! link Cursor ' . a:orig_cursor
        else
            execute 'highlight Cursor ' . a:orig_cursor
        endif
    else
        let &t_ve = a:orig_cursor
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
