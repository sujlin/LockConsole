local Logger = require("ma3lib.logger")
local State = require("model.state")

local Daemon = {}
Daemon.running = false
Daemon.tick = 0

function Daemon.start()
    if Daemon.running then
        Logger.info("Daemon already running") return end
    Daemon.running = true
    Logger.info("Daemon started")

    while Daemon.running do
        Daemon.tick = Daemon.tick + 1
        if Daemon.tick % 50 == 0 then
            Logger.info("alive tick=" .. Daemon.tick)
        end
        coroutine.yield(0.1)
    end

    Logger.info("Daemon ended")
end

function Daemon.stop()
    Daemon.running = false
    Logger.info("Daemon stopped")
end

function Daemon.cleanup()
    Logger.info("Daemon cleanup done")
    Daemon.running = false
end

return Daemon