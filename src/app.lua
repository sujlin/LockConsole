local Logger = require("ma3lib.logger")
local Service = require("src.service.action")
local Daemon = require("src.service.daemon")
local State = require("src.model.state")

local App = {}

function App.Main(display_handle, argument)
    Logger.info("Main called, argument=" .. tostring(argument))

    if argument == "start" then
        Daemon.start()
    elseif argument == "stop" then
        Daemon.stop()
    elseif argument == "status" then
        State.printStatus()
    else
        -- 普通动作/Executor/XKey 调用
        Service.handleAction(argument)
    end
end

function App.Cleanup()
    Logger.info("Cleanup called")
    Daemon.cleanup()
end

function App.Execute(Type, ...)
    Logger.info("Execute called Type=" .. tostring(Type))
    Service.handleExecute(Type, ...)
    return nil
end

return App