-----------------------------------------------------------------------------------------
--
-- common.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

function createBackButton(scene)

	--ERROR why doth this not go to top of page?
  local topBox = display.newImageRect("res/buttons/menu.png", 20, 20)
  topBox.x = display.contentCenterX - 160
  topBox.y = display.contentCenterY - 60
  topBox.anchorX = 0
  topBox.anchorY = 0
  topBox.scene = scene

  function topBox:touch( event )
      if event.phase == "ended" then
          composer.gotoScene("scenes." .. event.target.scene)
          return true
      end
  end

  topBox:addEventListener( "touch", topBox )

  return topBox
end

-- Function to handle button events
function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
		local animation
		local scene = event.target.id

		if(scene == 'onlinemenu') then
			animation = nil
		else
			animation = 'slideLeft'
		end

        composer.gotoScene("scenes." .. scene, {time = 500, effect = animation})
    end
end

function print_r ( t )  
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end	
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end