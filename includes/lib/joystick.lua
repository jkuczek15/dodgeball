--
-- a simple Lua/Corona joystick module based on Rob Miracle's code:
-- http://forums.coronalabs.com/topic/32941-virtual-joystick-module-for-games/
-- simplified some of the code, removing some nice-ities, but it still works

local Joystick = {}

function Joystick.new( innerRadius, outerRadius, player)
    local stage = display.getCurrentStage()
    
    local joyGroup = display.newGroup()
    
    local bgJoystick = display.newCircle( joyGroup, 0,0, outerRadius )
    bgJoystick.alpha = 0.5
    bgJoystick:setFillColor( .2,.2,.2 )
    
    local radToDeg = 180/math.pi
    local degToRad = math.pi/180
    local joystick = display.newCircle( joyGroup, 0,0, innerRadius )
    joystick.alpha = 0.8
    joystick:setFillColor( .8,.8,.8 )
    joystick.player = player

    -- for easy reference later:
    joyGroup.joystick = joystick
    
    -- where should joystick motion be stopped?
    local stopRadius = outerRadius - innerRadius
    
    -- return a direction identifier, angle, distance
    local directionX = 0
    local directionY = 0
    local angle = 0
    local distance = 0
    
    function joyGroup.getDirectionX()
    	return directionX
    end
    function joyGroup.getDirectionY()
    	return directionY
    end
    function joyGroup:getDistance()
    	return distance/stopRadius
    end
    
    function joystick:touch(event)
        local phase = event.phase

        if( (phase=='began') or (phase=="moved") ) then
        	if( phase == 'began' ) then
            	stage:setFocus(event.target, event.id)
            end
            local parent = self.parent
            local posX, posY = parent:contentToLocal(event.x, event.y)
            angle = (math.atan2( posX, posY )*radToDeg)-90
            if( angle < 0 ) then
            	angle = 360 + angle
            end

			-- could expand to include more directions (e.g. 45-deg)
            directionX = math.cos( math.rad( angle ) )
            directionY = -math.sin( math.rad( angle ) )
            distance = math.sqrt((posX*posX)+(posY*posY))
            
            if( distance >= stopRadius ) then
                distance = stopRadius
                local radAngle = angle*degToRad
                self.x = distance*math.cos(radAngle)
                self.y = -distance*math.sin(radAngle)
            else
                self.x = posX
                self.y = posY
            end
        else
            self.x = 0
			self.y = 0
            stage:setFocus(nil, event.id)
            
            directionId = 0
            angle = 0
            distance = 0
        end
        return true
    end
    
    function joyGroup:activate()
        self:addEventListener("touch", self.joystick )
        self.directionId = 0
        self.angle = 0
        self.distance = 0
    end
    function joyGroup:deactivate()
        self:removeEventListener("touch", self.joystick )
        self.directionId = 0
        self.angle = 0
        self.distance = 0
    end

    return( joyGroup )
end

return Joystick