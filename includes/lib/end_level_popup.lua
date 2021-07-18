-- End Level Popup
-- A simple popup window with three buttons - menu, restart and next.

local composer = require('composer')
local widget = require('widget')
local relayout = require('includes.lib.relayout')

local _M = {}

local newShade = require('includes.lib.shade').newShade

function _M.newEndGamePopup(params)
	local popup = display.newGroup()
	params.g:insert(popup)

	local background = display.newImageRect(popup, 'res/end_level.png', 300, 300)
	popup.x, popup.y = relayout._CX, -background.height

	local visualButtons = {}

	local label = display.newText({
		parent = popup,
		text = '',
		x = 0, y = -80,
		font = native.systemFontBold, 
		fontSize = 32
	})

	local menuButton = widget.newButton({
		defaultFile = 'res/buttons/menu.png',
		overFile = 'res/buttons/menu-over.png',
		width = 96, height = 105,
		x = -80, y = 80,
		onRelease = function()
			composer.gotoScene('scenes.startmenu', {time = 500, effect = 'slideRight'})			
		end
	})
	menuButton.isRound = true
	popup:insert(menuButton)
	table.insert(visualButtons, menuButton)

	local restartButton = widget.newButton({
		defaultFile = 'res/buttons/restart.png',
		overFile = 'res/buttons/restart-over.png',
		width = 96, height = 105,
		x = 80, y = menuButton.y,
		onRelease = function()
			composer.gotoScene(composer.getSceneName( "current" ), {params = params.levelId})
		end
	})
	restartButton.isRound = true
	popup:insert(restartButton)
	table.insert(visualButtons, restartButton)

	local superParams = params
	function popup:show(params)
		-- Shade dims the background and makes it impossible to touch
		--self.shade = newShade(superParams.g)

		if params.redWin then
			self.rotation = 0
			label.text = 'Red Wins!'
		else
			self.rotation = 180
			label.text = 'Blue Wins!'
		end
		
		--controller.setVisualButtons(visualButtons)
		self.x = relayout._CX
		transition.to(self, {time = 250, y = relayout._CY, transition = easing.outExpo, onComplete = function()
			relayout.add(self)
		end})
	end

	function popup:hide()
		-- Shade dims the background and makes it impossible to touch
		--self.shade:toBack()
		self:toBack()

		--controller.setVisualButtons(visualButtons)
		self.x = relayout._CX
		transition.to(self, {time = 250, y = relayout._CY, transition = easing.outExpo, onComplete = function()
			relayout.add(self)
		end})
	end
	return popup
end

return _M