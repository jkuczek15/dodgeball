 ----------------------------------------------------------------------------------
--
-- onlinefriendly.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require ( "sqlite3" )
local eachframe = require('includes.lib.eachframe') -- enterFrame manager
local physicsBorders = require( "includes.lib.physicsBorders" )
local physics = require( "physics" )
local scene = composer.newScene()
require "includes.game"

function scene:create( event )
	local sceneGroup = self.view
	
	-- Connect to the multiplayer server
	local gamesparks = multiplayerConnect()

	-- Add Playing field (background, score, etc)
	addPlayingField(sceneGroup, scene)

	-- Add Back button
	sceneGroup:insert(createBackButton("onlinemenu"))
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Only check once in a while for level end
		 addScoreCounter(sceneGroup)
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
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		resetGame()
		-- Called when the scene is now off screen
	end	
end


function scene:destroy( event )
	local sceneGroup = self.view
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