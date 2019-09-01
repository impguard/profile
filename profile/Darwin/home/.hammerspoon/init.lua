-- Base settings
hs.window.animationDuration = 0

-- Window management
units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

mash = { 'ctrl' }
prevWindowFrame = {}

function saveFrame(window, unit)
  local id = window:id()
  local prevFrame = prevWindowFrame[id]
  local currFrame = window:frame()

  local shouldSave =
    currFrame.w ~= unit.w and currFrame.h ~= unit.h and
    currFrame.x ~= unit.x and currFrame.y ~= unit.y

  if shouldSave then
    prevWindowFrame[id] = hs.geometry.copy(window:frame())
  end
end

hs.hotkey.bind(mash, 'right', function()
  local window = hs.window.focusedWindow()
  saveFrame(window, units.right50)
  window:move(units.right50, nil, true)
end)

hs.hotkey.bind(mash, 'left', function()
  local window = hs.window.focusedWindow()
  saveFrame(window, units.left50)
  window:move(units.left50, nil, true)
end)


hs.hotkey.bind(mash, 'up', function()
  local window = hs.window.focusedWindow()
  saveFrame(window, units.maximum)
  window:move(units.maximum, nil, true)
end)

hs.hotkey.bind(mash, 'down',  function()
  local window = hs.window.focusedWindow()
  local id = window:id()
  local prevFrame = prevWindowFrame[id]

  if prevFrame == nil then
    return
  end

  window:setFrame(prevFrame)
  prevWindowFrame[id] = nil
end)
