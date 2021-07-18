local Slider = {}
 
 function Slider.new( width, height, player)
    local stage = display.getCurrentStage()
    local sliderGroup = display.newGroup()
    
    local bgslider = display.newRect( sliderGroup, 0, 0, width, height )
	bgslider:setFillColor( 0.2, 0.2, 0.2 )
	bgslider.alpha = 0.5
    
    local slider = display.newCircle( sliderGroup, 0, 0, height-21 )
    slider.alpha = 0.8
    slider:setFillColor( .8,.8,.8 )
    slider.player = player

    -- for easy reference later:
    sliderGroup.slider = slider
    
    -- return a direction identifier, angle, distance
    local directionX = 0
    
    function sliderGroup.getDirectionX()
    	return directionX
    end
    
    function slider:touch(event)
        local phase = event.phase
        
        -- Set the max movement variables for the slider
        local xMax = 40
        local xMin = -40

        if( (phase=='began') or (phase=="moved") ) then
        	if( phase == 'began' ) then
            	stage:setFocus(event.target, event.id)
            end
            local parent = self.parent
            local posX, posY = parent:contentToLocal(event.x, event.y)
           
            -- Determine if we can move the slider
            if( posX >= xMax or posX <= xMin) then
                
                if( posX >= xMax ) then
                    self.x = xMax
                elseif( posX <= xMin) then
                    self.x = xMin
                end
            else
                -- Set the direction variable
                directionX = posX
                self.x = posX
            end
        else
            local player = event.target.slider.player
            if phase == 'ended'  then
                throwBall(player)
            end

            -- Uncomment to snap player back to normal rotation after throw
            -- Determine if we should move player back to original rotation
            -- if(player.isThrowing and player.myName == 'playerBlue') then
            --     player.rotation = 180
            -- elseif(player.isThrowing) then
            --     player.rotation = 0
            -- end

            directionX = 0
            self.x = 0
            self.y = 0
            stage:setFocus(nil, event.id)
        end
        return true
    end
    
    function sliderGroup:activate()
        self:addEventListener("touch", self.slider )
        self.directionX = 0
    end
    function sliderGroup:deactivate()
        self:removeEventListener("touch", self.joystick )
        self.directionX = 0
    end

    return( sliderGroup )
end

return Slider