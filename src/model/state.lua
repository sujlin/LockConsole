local State = {}
State.isLocked = false
State.actionCalls = 0
State.executeCalls = 0
State.failedAttempts = 0

function State.printStatus()
    print("=== LockConsole Status ===")
    print("Running:", State.isLocked)
    print("ActionCalls:", State.actionCalls)
    print("ExecuteCalls:", State.executeCalls)
    print("FailedAttempts:", State.failedAttempts)
    print("==========================")
end

return State