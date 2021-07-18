 ----------------------------------------------------------------------------------
--
-- onlineloading.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require ( "sqlite3" )
local eachframe = require('includes.lib.eachframe') -- enterFrame manager
local GS = require("plugin.gamesparks")
local gsrt = GS.getRealTimeServices()
local GameSession = require("includes.GameSession")
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

    local background = display.newImageRect("res/loading_background.png", 332, 302)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

	-- Connect to the multiplayer server
	local gs = multiplayerConnect()

    local function onMatchNotFound(errorMessage)
        -- If Match is not found, start a new request for a match
        print "Match not found."
        createMatchMakingRequest("QUICK")
    end

    local function onMatchFound(message)
        --When match is found, instantiate the real-time session
        mySession = GameSession.new(message:getAccessToken(), message:getHost(), message:getPort())

        -- Set the new callback depending on the packets you wish to recieve
        mySession.onPacketCB = function(packet)
            -- Choose what to do with a packet depending on its opCode
            print_r(packet)
            print "We are testing packets"
            -- if packet.opCode == 101 then
            --     -- Use packet.data to access the data in your packet and reference the type and index position of the variable
            --     local myText = display.newText( packet.data:getString(1), display.contentCenterX, display.contentCenterY, native.systemFont, 30 )
            --     myText:setFillColor( 1, 1, 1 )
            -- end
        end

        -- Start game and change the scene
        composer.gotoScene("scenes.onlinequick")
    end

    -- Set listeners
    gs.getMessageHandler().setMatchFoundMessageHandler(onMatchFound)
    gs.getMessageHandler().setChallengeStartedMessageHandler(onChallengeStarted)
    gs.getMessageHandler().setMatchNotFoundMessageHandler(onMatchNotFound)
    gs.getMessageHandler().setMatchFoundMessageHandler(onMatchFound)

	-- Create a new match making request
	createMatchMakingRequest("QUICK")

    -- Add Back button
	sceneGroup:insert(createBackButton("onlinemenu"))
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Only check once in a while for level end
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