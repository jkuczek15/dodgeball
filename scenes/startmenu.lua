----------------------------------------------------------------------------------
--
-- startmenu.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
require("includes.common")

---------------------------------------------------------------------------------

local buttonMenu =
{
	{label = "Local Game", scene = "local"},
	{label = "Online Game", scene = "onlinemenu"},
	{label = "Options", scene = "options"}
}

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect("res/basketball-court.png", 424, 637)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	-- if(self.endGamePopup) then
	-- 	self.endGamePopup:hide()
	-- end
	local backgroundMusic = audio.loadStream( "Shoes Squeaking on Floor.mp3" )
	local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1 } )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc
	local titleGroup = display.newGroup()
	local options = display.newGroup()
	
	--Create title background box 
	local rect = display.newRect( 0, 0, 250, 100)
	local paint = {1}
	rect.fill = paint
	rect.alpha = 0.8
	local lineBreak = display.newRect( 0, 63, 225, 10)
	paint = {1}
	lineBreak.fill = paint
	lineBreak.alpha = 0.8

	local title = display.newText("Dodgeball", 0, 0, native.systemFont, 32 )
	title:setFillColor(0)

	--insert title and box
	titleGroup:insert(lineBreak)
	titleGroup:insert( rect )
	titleGroup:insert( title )

	for i=1, #buttonMenu do
		local posX = 0
		local posY = 215 + ((i - 1) * 115)
		local rect = display.newRect( posX, posY, 250, 100)
		local paint = {1}
		rect.fill = paint
		rect.alpha = 0.8
		options:insert(rect)
		options:insert(widget.newButton
			{
				x = posX, 
				y = posY,
				id = buttonMenu[i].scene,
				label = buttonMenu[i].label,
				onEvent = handleButtonEvent,
				scene = buttonMenu[i].scene,
				fontSize = 30,
				labelColor = {default={0, 0, 0, 1}, over={0,0,0,0}}
			})
		
	end

	options.x = display.contentCenterX
	titleGroup.x = display.contentCenterX
	titleGroup.y = display.contentCenterY - 150
	sceneGroup:insert(options)
	sceneGroup:insert(titleGroup)
	
	--sceneGroup:insert(optionsButton);
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		audio.stop()
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end


function scene:destroy( event )
	local sceneGroup = self.view
	audio.stop()
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene