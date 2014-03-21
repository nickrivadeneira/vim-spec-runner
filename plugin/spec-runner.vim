let s:spec_runner_command = '"{preloader} {runner} {options} {path}{focus}"'

if !exists('g:spec_runner_executor')
  let g:spec_runner_executor = '!echo {command} && command'
endif

function! s:RunCurrentFile()
  call s:RunSpecCommand(s:SpecCommand('unfocused'))
endfunction

function! s:RunSpecCommand(command)
  let executable_command = substitute(g:spec_runner_executor, '{command}', a:command, 'g')
  execute executable_command
endfunction

function! s:SpecCommand(is_focused)
  let runner = s:Runner()
  let preloader = s:Preloader(runner)
  let options = s:Options(runner)
  let path = s:Path()
  let focus = s:Focus(runner, a:is_focused)

  return s:InterpolateCommand(runner, preloader, options, path, focus)
endfunction

function! s:Runner()
  return 'rspec'
endfunction

function! s:Preloader(runner)
  if filereadable('zeus.json')
    return 'zeus'
  elseif s:FileContains('Gemfile.lock', 'spring-commands-rspec')
    return 'spring'
  else
    return ''
  endif
endfunction

function! s:Options(runner)
  return ''
endfunction

function! s:Path()
  return ''
endfunction

function! s:Focus(runner, is_focused)
  return ''
endfunction

function! s:FileContains(filename, text)
  return filereadable(a:filename) && match(readfile(a:filename), a:text) != -1
endfunction

function! s:InterpolateCommand(runner, preloader, options, path, focus)
  let result=s:spec_runner_command
  let map={
        \ '{runner}' : a:runner,
        \ '{preloader}' : a:preloader,
        \ '{options}' : a:options,
        \ '{path}' : a:path,
        \ '{focus}' : a:focus,
        \ }
  for [placeholder, value] in items(map)
    let result = substitute(result, placeholder, value, 'g')
  endfor

  return result
endfunction

command! RunCurrentFile call s:RunCurrentFile()
