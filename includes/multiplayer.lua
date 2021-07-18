-- the gamesparks plugin
local gs

-- current user authentication token
local auth_token

function multiplayerConnect()
    
	local function availabilityCallback(isAvailable)
        -- Writes 'true' to the console if the server is available
		writeText("Server Available: " .. tostring(isAvailable) .. "\n")

		if isAvailable then
			--Do something
		end
	end

	--Create GS Instance
	gs = createGS()
	
    --Set the logger for debugging the Responses, Messages and Requests flowing in and out
	gs.setLogger(writeText)
	
    --Set API Key
	gs.setApiKey("s314532p7ldu")
	
    --Set Secret
	gs.setApiSecret("dcABzoBsrnozMckRXPsdy1mW5fWMKTKh")
	
    --Set Credential
	gs.setApiCredential("device")
	
    --Set availability callback function
	gs.setAvailabilityCallback(availabilityCallback)
	
    --Connect to your game's backend
	gs.connect()

    --Authenticate using the devices unique ID
    authenticate()

    return gs
end

function authenticate()
    --Build request
    local requestBuilder = gs.getRequestBuilder()
    local deviceAuthenticationRequest = requestBuilder.createDeviceAuthenticationRequest()

    --Set values
    deviceAuthenticationRequest:setDeviceId(system.getInfo( "deviceID" ))
    deviceAuthenticationRequest:setDeviceOS("Corona")

    --Send and print authentication token
    deviceAuthenticationRequest:send(
        function(authenticationResponse)
            auth_token = authenticationResponse:getAuthToken()
            if(auth_token ~= nil) then
                writeText("token: " .. auth_token .. "\n")
            end
        end
    )
end

function createMatchMakingRequest(shortCode)
    --Create request
    local requestBuilder = gs.getRequestBuilder()
    local matchmakingRequest = requestBuilder.createMatchmakingRequest()

    --Set values for the short code and skill variable
    matchmakingRequest:setSkill(1)
    matchmakingRequest:setMatchShortCode(shortCode)

    --Send request
    matchmakingRequest:send()
end

function writeText(string)
    print(string)
end