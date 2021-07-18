local Borders = {}

function Borders.makeBorders()
 	
	local borderGroup = display.newGroup()
                                                  -- change these values to fit your needs.
		borderBodyElement = {  }
	                                                         -- (x, y, width, height)
		local borderTop = display.newRect( 0, -35, 2*display.contentWidth, 0 ) 
			  borderTop:setFillColor( 0, 0, 0)
		      physics.addBody( borderTop, "static", borderBodyElement )
	
                                                                     -- (x, y, width, height)
		local borderBottom = display.newRect( 0, display.contentHeight+35, 2*display.contentWidth, 0 )
			  borderBottom:setFillColor( 0, 0, 0)
			  physics.addBody( borderBottom, "static", borderBodyElement )
	
                                                                 -- (x, y, width, height)
		local borderLeft = display.newRect( 0, 0, 0, 3*display.contentHeight )
			  borderLeft.myName = 'wall'
			  borderLeft:setFillColor( 0, 0, 0)	
			  physics.addBody( borderLeft, "static", borderBodyElement )
	                                                           
                                                                  -- (x, y, width, height)
		local borderRight = display.newRect( display.contentWidth, 0, 0, 3*display.contentHeight )
			  borderRight.myName = 'wall'
			  borderRight:setFillColor( 0, 0, 0)
			  physics.addBody( borderRight, "static", borderBodyElement )
	
		
			borderGroup:insert(borderTop);
			borderGroup:insert(borderBottom);
			borderGroup:insert(borderLeft);
			borderGroup:insert(borderRight);
			borderGroup.isVisible = false;
	
	return borderGroup
end

return Borders