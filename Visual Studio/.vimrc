set relativenumber
set ignorecase
set smartcase
set incsearch

:nmap gc :vsc Edit.ToggleLineComment<CR>
:vmap gc :vsc Edit.ToggleLineComment<CR><Esc>
:nmap <C-O> :vsc View.NavigateBackward<CR>zz
:nmap <C-I> :vsc View.NavigateForward<CR>zz

:vnoremap y "+y
:nnoremap p "+p
:vnoremap p "+p

"Maintain cut behaviour in visual mode, press s to substitute, not sure how to do this
":vnoremap p "+d"+p

:nnoremap yy "+yy
:nnoremap yw "+yw
:nnoremap yiw "+yiw
:nnoremap yaw "+yaw
:nnoremap yas "+yas
:nnoremap yib "+yib
:nnoremap yab "+yab
:nnoremap ya{ "+ya{
:nnoremap yi{ "+yi{
:nnoremap ya( "+ya(
:nnoremap yi( "+yi(
:nnoremap yi\" "+yi"
:nnoremap yi' "+yi'
:nnoremap ya\" "+ya"
:nnoremap ya\' "+ya'

:nnoremap dd "_dd
:nnoremap dw "_dw
:nnoremap diw "_diw
:nnoremap daw "_daw
:nnoremap das "_das
:nnoremap dib "_dib
:nnoremap dab "_dab
:nnoremap da{ "_da{
:nnoremap di{ "_di{
:nnoremap da( "_da(
:nnoremap di( "_di(

:nnoremap Dd "+dd
:nnoremap Dw "+dw
:nnoremap Diw "+diw
:nnoremap Daw "+daw
:nnoremap Das "+das
:nnoremap Dib "+dib
:nnoremap Dab "+dab
:nnoremap Da{ "+da{
:nnoremap Di{ "+di{
:nnoremap Da( "+da(
:nnoremap Di( "+di(

:nnoremap cw "_cw
:nnoremap ciw "_ciw
:nnoremap caw "_caw
:nnoremap cas "_cas
:nnoremap cib "_cib
:nnoremap cab "_cab
:nnoremap ca{ "_ca{
:nnoremap ci{ "_ci{
:nnoremap ca( "_ca(
:nnoremap ci( "_ci(

:nnoremap Cw "+cw
:nnoremap Ciw "+ciw
:nnoremap Caw "+caw
:nnoremap Cas "+cas
:nnoremap Cib "+cib
:nnoremap Cab "+cab
:nnoremap Ca{ "+ca{
:nnoremap Ci{ "+ci{
:nnoremap Ca( "+ca(
:nnoremap Ci( "+ci(
":nnoremap <Space>d "_d
":vnoremap <Space>d "_d

":nmap <Space>p "0p

":vmap <Space>p "0P
":vmap <Space>P "_d"0P
:nunmap s
:nnoremap s "_ciw<C-r>"<Esc>
:nnoremap S "ciw<C-r>"<Esc>
:vmap s "_dP

:nnoremap ss <Nop>

:nnoremap <Space>gy "+y
:vnoremap <Space>gy "+y

:nnoremap <Space>gp "+p
:vnoremap <Space>gp "+p

:nnoremap x "_x
:nnoremap cc "_cc

:nnoremap <BS> "_ciw
:nnoremap <Del> "_diw
:vnoremap <Del> "_diw

:nmap gd :vsc Edit.GoToDefinition<CR><Esc>
:nmap gI :vsc Edit.GoToImplementation<CR>
