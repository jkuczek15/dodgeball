-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
local simpleJoystick = require( "includes.lib.joystick" )
local simpleSlider = require( "includes.lib.slider" )
local newEndGamePopup = require('includes.lib.end_level_popup').newEndGamePopup
local physicsBorders = require( "includes.lib.physicsBorders" )
-----------------------------------------------------------------------------------------

-- Define constants
local PLAYER_SPEED = 3.15
local JOYSTICK_SENSITIVITY = 0.25
local ROTATION_MAX = 1.7
local BALL_SPEED = 700

-- Initialize player objects for global use
local redPlayer
local bluePlayer

-- Initialize player score objects
local redCount
local blueCount

-- Game ending popup
local endGamePopup

function throwBall( player )
	-- function to throw a ball from a player <player> across the court
	if (player.isBodyActive and not player.isThrowing) then
		-- display a new ball on the screen
		local ball = display.newImageRect("res/ball.png", 20, 20)
		physics.addBody( ball, "dynamic", { bounce=0.7 } )
		ball.isBullet = true

		-- set the ball to have a pre collision event
		local function preCollisionEvent( self, event )
			local collideObject = event.other

			event.contact.isEnabled = false  --disable this specific collision
			if ( collideObject.myName == 'wall' ) then
				event.contact.isEnabled = true  --disable this specific collision
			end
		end

		ball.preCollision = preCollisionEvent
		ball:addEventListener( "preCollision" )

		-- player colliding upon throwing to fix bug where player collides with themselves
		player.isColliding = true
		
		-- set the ball to be thrown from the players arm
		if(player.myName == 'playerBlue') then
			ball.x = player.x - 20
			ball.y = player.y + 5
		else
			ball.x = player.x + 20
			ball.y = player.y - 5
		end
		
		-- Bring the ball to the front scene
		ball.myName = 'ball'
		ball:toFront()
		
		-- Get the linear velocity from the rotation + BALL_SPEED
		local function getLinearVelocity(rotation, velocity)
			local angle = math.rad(rotation)
			return {
				xVelocity = math.sin(angle) * velocity,
				yVelocity = math.cos(angle) * -velocity
			}
		end

		-- Get the linear velocity of the ball using the player's rotation
		local ballLinearVelocity = getLinearVelocity(player.rotation, BALL_SPEED)
		ball:setLinearVelocity(ballLinearVelocity.xVelocity, ballLinearVelocity.yVelocity)
		
		-- Block the players from spamming balls (3 seconds)
		player.isThrowing = true 
		transition.to( player, { time=300,
			onComplete = function()
				player.isThrowing = false
			end
		})
	end
	
	return true
end

function addLocalPlayers( sceneGroup )
	-- Function use to add local players to the game

	local function onTimer( event )
		-- Function to be called each frame of a timer (used for joystick)
		local params = event.source.params
		local joystick = params.joystick
		local player = params.player
		local slider = params.slider
		
		-- Grab joystick data
		local directionX = joystick:getDirectionX()
		local directionY = joystick:getDirectionY()
		local distance = joystick:getDistance()
		
		-- Grab slider data
		local sliderDirection = slider:getDirectionX()

		-- Determine if we should rotate the player
		if(sliderDirection > 0 or sliderDirection < -0) then
			-- Rotate player based on the color
			if(player.myName == "playerBlue") then
				player.rotation = 180 - (ROTATION_MAX * sliderDirection)
			else
				player.rotation = (ROTATION_MAX * sliderDirection)
			end
		end
		
		-- Determine if we should move the player
		if ( distance > JOYSTICK_SENSITIVITY ) then
			-- Move player
			player.x = player.x + (directionX * distance * PLAYER_SPEED)
			player.y = player.y + (directionY * distance * PLAYER_SPEED)
		end

		return true
	end

	addPlayer(sceneGroup, 'blue', onTimer)
	addPlayer(sceneGroup, 'red', onTimer)
end

function addPlayer( sceneGroup, color, onTimer )
	local imagePath
	
	-- Set the player's image path
	if color == 'blue' then
		imagePath = "res/player_blue.png"
	else
		imagePath = "res/player_red.png"
	end

	local player = display.newImageRect(imagePath, 50, 36)
	local joystick = simpleJoystick.new( 20, 40, player )
	local slider = simpleSlider.new(100, 35, player)

	if color == 'blue' then
		-- Set position of blue player
		player.y = display.contentCenterY - 150
		player.rotation = 180
		player.myName = 'playerBlue'
		-- Set the position of joystick and slider
		joystick.x = display.contentCenterX + 120
		joystick.y = display.contentCenterY - 240
		slider.x = display.contentCenterX - 110
		slider.y = display.contentCenterY - 217
	else
		-- Set position of red player
		player.y = display.contentCenterY + 150
		player.myName = 'playerRed'
		-- Set the position of joystick and slider
		joystick.x = display.contentCenterX - 120
		joystick.y = display.contentCenterY + 240
		slider.x = display.contentCenterX + 110
		slider.y = display.contentCenterY + 217
	end

	-- Activate the joystick and slider with the onTimer function
	slider:activate()
	joystick:activate()
	local tm = timer.performWithDelay( 10, onTimer, -1 )
	tm.params = { slider = slider, joystick = joystick, player = player }
	
	-- Add common player properties
	player.x = display.contentCenterX
	player.baseX = player.x
	player.baseY = player.y
	physics.addBody( player, "dynamic")

	-- Store the created player for global use
	if color == 'blue' then
		bluePlayer = player
	else
		redPlayer = player
	end
	
	-- Insert the player and joystick into the scene
	sceneGroup:insert(player)
	sceneGroup:insert(joystick)
	sceneGroup:insert(slider)
end

function addPlayingField( sceneGroup, scene)
    -- Add the physics borders
	physicsBorders.makeBorders()
		
    -- Set the background
	local background = display.newImageRect("res/basketball-court.png", 360, 570)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
    -- Add the center separator
	local separator = display.newImageRect("res/court-separator.PNG", 360, 7)
	separator.x = display.contentCenterX
	separator.y = display.contentCenterY
	physics.addBody(separator, "static")
	sceneGroup:insert(separator) 
end

function restorePlayer(event)
    local player = event.source.params.player
    player.isBodyActive = false
    player.x = player.baseX
    player.y = player.baseY

    -- Fade in the player
    transition.to( player, { alpha=1, time=500,
        onComplete = function()
            player.isBodyActive = true
        end
    } )
end

function addScoreCounter( sceneGroup )
	-- Add the end game dialog popup
	endGamePopup = newEndGamePopup({g = sceneGroup})

	-- Set Score Counter
	if(blueCount ~= nil and redCount ~= nil) then
		sceneGroup.blueCount = blueCount
		sceneGroup.redCount = redCount
	else
		sceneGroup.blueCount = display.newText(0, 15, 0, native.systemFont, 32 )
		sceneGroup.redCount = display.newText(0, 15, 0, native.systemFont, 32 )
		sceneGroup.blueCount:rotate(90)
		sceneGroup.redCount:rotate(90)
		sceneGroup.blueCount.y =  display.contentCenterY + 20
		sceneGroup.redCount.y =  display.contentCenterY - 20
	end 
	sceneGroup:insert(sceneGroup.blueCount)
	sceneGroup:insert(sceneGroup.redCount)
	sceneGroup.blueCount:toFront()
	sceneGroup.redCount:toFront()

	-- Set the lives text objects
    blueCount = sceneGroup.blueCount
    redCount = sceneGroup.redCount
end

function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2
        if ( ( obj1.myName == "playerRed" and obj2.myName == "ball" and not obj1.isColliding ) or
            ( obj1.myName == "ball" and obj2.myName == "playerRed" and not obj2.isColliding ) )
        then
            if(obj1.myName == "playerRed") then
                obj1.alpha = 0
                redCount.text = redCount.text + 1
                local tm = timer.performWithDelay(0, restorePlayer )
                tm.params = { player = obj1 }
            else
                obj2.alpha = 0
                redCount.text = redCount.text + 1
                local tm = timer.performWithDelay(0, restorePlayer )
                tm.params = { player = obj2 }
            end
        elseif ( ( obj1.myName == "playerBlue" and obj2.myName == "ball" and not obj1.isColliding ) or
                ( obj1.myName == "ball" and obj2.myName == "playerBlue" and not obj2.isColliding ) )
        then
            if(obj1.myName == "playerBlue") then
                obj1.alpha = 0
                blueCount.text = blueCount.text + 1
                local tm = timer.performWithDelay(0, restorePlayer )
                tm.params = { player = obj1 }
            else
                obj2.alpha = 0
                blueCount.text = blueCount.text + 1
                local tm = timer.performWithDelay(0, restorePlayer )
                tm.params = { player = obj2 }
            end
        end
        obj1.isColliding = false
        obj2.isColliding = false
        endGameCheck()
    end
end

function endGameCheck()
	local redWin = nil
	-- Check if the player won or lost
    if (tonumber(redCount.text) >= 3) then
		-- THIS SHIT IS SO FUCKED UP, should be the other way around
		redWin = false 
    elseif(tonumber(blueCount.text) >= 3) then
		redWin = true
    end

	if redWin ~= nil then
		endGamePopup:show({redWin = redWin})
		endGamePopup:toFront()
	end
end

function resetGame()
    endGamePopup:hide()
	blueCount.text = 0
	redCount.text = 0
	
	if(bluePlayer ~= nil and redPlayer ~= nil) then
		resetPlayerPosition(bluePlayer)
		resetPlayerPosition(redPlayer)
	end
end

function resetPlayerPosition(player)
	player.x = player.baseX
	player.y = player.baseY
end