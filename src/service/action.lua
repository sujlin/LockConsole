local Logger = require("ma3lib.logger")
local State = require("model.state")

local Service = {}

function Service.handleAction(argument)
    State.actionCalls = (State.actionCalls or 0) + 1
    Logger.info("Action called count=" .. State.actionCalls)
    Logger.info("Action argument=" .. tostring(argument))
end

function Service.handleExecute(Type, ...)
    Logger.info("Execute event received: " .. tostring(Type))
    local args = {...}
    for i = 1, #args do
        Logger.info("Arg" .. i .. ": " .. tostring(args[i]))
    end
end

return Service