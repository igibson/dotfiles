require("relative-motions"):setup({ show_numbers = "relative", show_motion = true })
require("full-border"):setup()

function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    local size = self._file:size()
    
    local time_str = os.date("%Y-%m-%d %H:%M", time)
    local size_str = size and ya.readable_size(size) or "-"
    
    return ui.Line(string.format("%s  %s", size_str, time_str))
end
