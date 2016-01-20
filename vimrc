function Getparams()
    let s:start = line('.')
    let s:end = search("{")
    if stridx(getline(s:end),"{") == 0
        let s:end = s:end - 1
    endif
    let s:lines=getline(s:start,s:end)
    let linesCnt=len(s:lines)
    let mlines=join(s:lines)
    let mlines=substitute(mlines," ","","g")
    let paraFlag1=stridx(mlines,'(')
    let paraFlag2=strridx(mlines,')')
    let paraLen=paraFlag2-paraFlag1-1
    let parastr=strpart(mlines,paraFlag1+1,paraLen)
    let alist=[]
    if  stridx(parastr,',') != -1
       let s:paras=split(parastr,',')
       let s:idx=0
       while s:idx < len(s:paras)
             if stridx(s:paras[s:idx],'=') != -1
                  let s:realpara = split(s:paras[s:idx],'=')[0]
             else
                  let s:realpara = s:paras[s:idx]
             endif
             "strip the leading blanks
             "call append(s:start - 1 + s:idx , "#' @param " . s:realpara)
             call add(alist,s:realpara)
             let s:idx = s:idx + 1
       endwhile
    else
       "call append(s:start-1,parastr) 
       if parastr != ""
          call add(alist,parastr)
       endif
    endif
    return alist
endfunction

function  Rdoc()
    let s:wd=expand("")
    let s:lineNo=line('.')-1
    let plist=Getparams()
    call append(s:lineNo,"#' title ")
    call append(s:lineNo + 1,"#' ")
    call append(s:lineNo + 2,"#' description")
    call append(s:lineNo + 3,"#' ")
    let s:idx =0
    while s:idx < len(plist)
        call append(s:lineNo + 4 + s:idx , "#' @param " . plist[s:idx] . " value")
        let s:idx = s:idx + 1
    endwhile
    call append(s:lineNo + 4 + s:idx,"#' @return returndes")
    call append(s:lineNo + 4 + s:idx + 1,"#' @export ")
    call append(s:lineNo + 4 + s:idx + 2,"#' @examples ")
    call append(s:lineNo + 4 + s:idx + 3,"#' x=c(1,2,3) ")
endfunction


nmap <F3> :call Rdoc() <CR>

