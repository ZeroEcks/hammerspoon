-- Grid setup
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 4
hs.grid.GRIDHEIGHT = 2

keyLayout = {{'q', 'w', 'e', 'r'}, {'a', 's', 'd', 'f'}}

-- a helper function that returns another function that resizes the current window
-- to a certain grid size.
local gridset = function(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        hs.grid.set(win, {
            x = x,
            y = y,
            w = w,
            h = h
        }, win:screen())
    end
end

local getArea = function(first, second)
    firstX = first[1]
    firstY = first[2]
    secondX = second[1]
    secondY = second[2]

    colStart = math.min(firstX, secondX);
    rowStart = math.min(firstY, secondY);
    colEnd = math.max(firstX, secondX);
    rowEnd = math.max(firstY, secondY);

    return {rowStart, colStart, rowEnd - rowStart + 1, colEnd - colStart + 1}
end

keypresses = {}
wmTrigger = function(keycode, row, col)
    keypresses[#keypresses + 1] = {keycode, row, col}
    if #keypresses >= 1 then
        first = {keypresses[1][3], keypresses[1][2]}
        second = {keypresses[2][3], keypresses[2][2]}

        area = getArea(first, second)

        topX = area[1] - 1
        topY = area[2] - 1
        height = area[3]
        width = area[4]

        print("topX", topX)
        print("topY", topY)
        print("width", width)
        print("height", height)

        gridset(topY, topX, width, height)()

        keypresses = {}
        windowHotkey:exit()
    end
end

-- Actually bind everything

windowHotkey = hs.hotkey.modal.new({}, 'F17')
pressedWindowHotkey = function()
    windowHotkey:enter()
end

releasedWindowHotkey = function()
    windowHotkey:exit()
end

windowHotkey:exited(function()
    keypresses = {}
end)

windowHotkey:bind('', 'escape', function()
    windowHotkey:exit()
end)

for row = 1, #keyLayout do
    for col = 1, #keyLayout[1] do
        key = keyLayout[row][col]
        windowHotkey:bind('', key, key, function()
            wmTrigger(key, row, col)
        end)
    end
end

-- Halves of screen
function windowToLeftHalf()
    gridset(0, 0, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT)()
end

function windowToRightHalf()
    gridset(hs.grid.GRIDWIDTH / 2, 0, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT)()
end

function windowToTopHalf()
    gridset(0, 0, hs.grid.GRIDWIDTH, hs.grid.GRIDHEIGHT / 2)()
end

function windowToBottomHalf()
    gridset(0, hs.grid.GRIDHEIGHT / 2, hs.grid.GRIDWIDTH, hs.grid.GRIDHEIGHT / 2)()
end

-- Quaters of screen
function windowToTopLeft()
    gridset(0, 0, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT / 2)()
end

function windowToTopRight()
    gridset(hs.grid.GRIDWIDTH / 2, 0, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT / 2)()
end

function windowToBottomLeft()
    gridset(0, hs.grid.GRIDHEIGHT / 2, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT / 2)()
end

function windowToBottomRight()
    gridset(hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT / 2, hs.grid.GRIDWIDTH / 2, hs.grid.GRIDHEIGHT / 2)()
end

-- Fullscreen
function windowToFullscreen()
    gridset(0, 0, hs.grid.GRIDWIDTH, hs.grid.GRIDHEIGHT)()
end