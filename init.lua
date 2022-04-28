require "wm"

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F17')

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
    hyper.triggered = false
    hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
    hyper:exit()
    if not hyper.triggered then
        hs.eventtap.keyStroke({}, 'ESCAPE')
    end
end

function triggerHyperMode(func)
    return function()
        hyper.triggered = true
        print("trigger hyper mode with ", func)
        func()
    end
end

-- Navigation
hyper:bind({}, "e", triggerHyperMode(hs.hints.windowHints))
-- Eights
hyper:bind({}, 'a', nil, triggerHyperMode(pressedWindowHotkey), releasedWindowHotkey)
-- Halves
hyper:bind({}, "left", windowToLeftHalf)
hyper:bind({}, "right", windowToRightHalf)
hyper:bind({}, "up", windowToTopHalf)
hyper:bind({}, "down", windowToBottomHalf)
-- Quarters
hyper:bind({}, "u", windowToTopLeft)
hyper:bind({}, "i", windowToTopRight)
hyper:bind({}, "j", windowToBottomLeft)
hyper:bind({}, "k", windowToBottomRight)
-- Fullscreen
hyper:bind({}, "return", windowToFullscreen)

-- Bind the Hyper key
f19 = hs.hotkey.bind({}, 'F19', enterHyperMode, exitHyperMode)
