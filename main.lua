
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Required Inlcudes -- 
-----------------------------------------------------------------------------------------
local composer = require "composer"
local GS = require("plugin.gamesparks")
local gsrt = GS.getRealTimeServices()
local GameSession = require("includes.GameSession")
local physics = require( "physics" )
require "includes.common"
require "includes.multiplayer"
require "includes.game"
-----------------------------------------------------------------------------------------
-- Declare our real-time game session
local mySession = nil

-- Device system settings
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- Init Physics
physics.start()
physics.setGravity( 0, 0 )

-- Uncomment this to debug physics
-- physics.setDrawMode( "hybrid" )

--- Add a collision event listener
Runtime:addEventListener( "collision", onCollision )

-- load scenetemplate.lua
composer.gotoScene( "scenes.startmenu" )