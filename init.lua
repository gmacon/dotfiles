local tiling = require 'hs.tiling'
local hotkey = require 'hs.hotkey'
local mash = {'ctrl', 'cmd', 'alt', 'shift'}
layout = 'main-vertical-variable'
border = nil

local log = hs.logger.new('bbenne10Config','debug')

-- utility functions
function applyLayout(newLayout)
  layout = newLayout
  tiling.goToLayout(layout)
end

function drawBorder()
    if border then
        border:delete()
    end

    local win = hs.window.focusedWindow()
    if win == nil then return end

    local f = win:frame()
    local fx = f.x - 2
    local fy = f.y - 2
    local fw = f.w + 4
    local fh = f.h + 4

    border = hs.drawing.rectangle(hs.geometry.rect(fx, fy, fw, fh))
    border:setStrokeWidth(3)
    border:setStrokeColor({["red"]=0.75,["blue"]=0.14,["green"]=0.83,["alpha"]=0.80})
    border:setRoundedRectRadii(5.0, 5.0)
    border:setStroke(true):setFill(false)
    border:setLevel("floating")
    border:show()
end

-- implementation functions
function setup()
  hs.window.animationDuration = 0
  local configWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', hs.reload):start()
  --wf:sub
  windows = hs.window.filter.new(nil)
  windows:subscribe(hs.window.filter.windowFocused, function () drawBorder() end)
  windows:subscribe(hs.window.filter.windowUnfocused, function () drawBorder() end)
  windows:subscribe(hs.window.filter.windowMoved, function () drawBorder() end)
  windows:subscribe(hs.window.filter.windowCreated, function () tiling.goToLayout(layout) end)
  windows:subscribe(hs.window.filter.windowDestroyed, function () tiling.goToLayout(layout) end)
  setupKeybinds()
  drawBorder()
end

function setupKeybinds() 
  expose = hs.expose.new(nil) -- default windowfilter, no thumbnails

  -- basic tiling commands
  hotkey.bind(mash, 'j', function() tiling.cycle(1) end)
  hotkey.bind(mash, 'k', function() tiling.cycle(-1) end)
  hotkey.bind(mash, 'h', function() tiling.adjustMainVertical(-0.05) end)
  hotkey.bind(mash, 'l', function() tiling.adjustMainVertical(0.05) end)
  hotkey.bind(mash, 'return', function() tiling.promote() end)

  -- layout stuff
  hotkey.bind(mash, 'space', function() tiling.cycleLayout() end)
  hotkey.bind(mash, 'm', function() applyLayout('fullscreen') end)
  hotkey.bind(mash, 't', function() applyLayout('main-vertical-variable') end)
  hotkey.bind(mash, 'b', function() applyLayout('main-horizontal') end)

  -- Launching externals
  hs.hotkey.bind({'cmd', 'shift'}, 't', function () hs.application.launchOrFocus('iterm') end)

  hs.hotkey.bind(mash,'e','Expose',function()expose:toggleShow()end)
end

setup()

