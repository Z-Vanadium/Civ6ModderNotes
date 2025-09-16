-- File:    VanadiumModCore.lua
-- Author:  Vanadium
-- Target:  Common method set in lua script debug process
-----------------------------------------------------------

-- module definition
VanadiumModCore = {}

local DEBUG = false

function VanadiumModCore:__Debug(...)
    if DEBUG then
        print(...)
    end
end

-- print the whole table
function VanadiumModCore:ShowTable(tTable, indent)
    indent = indent or 0

    for k, v in pairs(tTable) do
        if type(v) == "table" then
            print(string.rep(" ", indent) .. k .. ": {")
            printTable(v, indent + 4)
            print(string.rep(" ", indent) .. "}")
        else
            print(string.rep(" ", indent) .. k .. ": " .. tostring(v))
        end
    end
end

-- check whether player's leader type matches
function VanadiumModCore:CheckLeaderMatched(playerID, leaderType)
    local pPlayerConfig = playerID and PlayerConfigurations[playerID]
    return pPlayerConfig and pPlayerConfig:GetLeaderTypeName() == leaderType
end

-- check whether player's civilization type matches
function VanadiumModCore:CheckCivilizationMatched(playerID, civilizationType)
    local pPlayerConfig = playerID and PlayerConfigurations[playerID]
    return pPlayerConfig and pPlayerConfig:GetCivilizationTypeName() == civilizationType
end

local USE_CACHE = true;
local g_ObjectStateCache = {}

-- set property (work in both gameplay and ui environment)
function VanadiumModCore:SetObjectState(pObject, sPropertyName, value)
    if (sPropertyName == nil) then return nil; end

    if (pObject == nil) then
        print("VanadiumModCore SET OBJECT STATE: ERROR: OBJECT IS NIL!");
        return nil;
    end

    if (USE_CACHE == true) then
        if (g_ObjectStateCache[pObject] == nil) then
            g_ObjectStateCache[pObject] = {};
        end
        g_ObjectStateCache[pObject][sPropertyName] = value;
    end

    if UI ~= nil then
        local kParameters = {};
        kParameters.propertyName = sPropertyName;
        kParameters.value = value;
        kParameters.objectID = pObject:GetComponentID();
        kParameters.OnStart = "OnPlayerCommandSetObjectState";
        UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters);
    else
        if (pObject.SetProperty ~= nil) then
            pObject:SetProperty(sPropertyName, value);
        end
    end
end

function OnPlayerCommandSetObjectStateHandler(ePlayer, params)
	local pObject = Game.GetObjectFromComponentID(params.objectID);
	if pObject ~= nil then
		SetObjectState(pObject, params.propertyName, params.value);
	end
end

if UI == nil then
	GameEvents.OnPlayerCommandSetObjectState.Add( OnPlayerCommandSetObjectStateHandler );
end