local Logger = require("ma3lib.logger")
local State = require("src.model.state")

local PinUI = {}

-- 默认 PIN，可在 config 或 State 初始化时替换
PinUI.correctPin = "1234"

-- 弹出 MessageBox 输入 PIN
function PinUI.showPinDialog()
    Logger.info("PIN Dialog: Please enter your numeric PIN")

    -- 创建 MessageBox
    local MessageBox = require("src.ui.messagebox") -- 复用现有 MessageBox 封装
    local mb = MessageBox.Create()
    
    -- 模拟输入，实际 MA3 上会弹出输入框
    -- 这里提供 callback 回调，输入完成后触发
    mb:FocusTextInput("PIN_Input") -- 假设 LineEdit 名称为 PIN_Input
    
    -- 监听确认按钮
    mb:SelectCommand("Unlock") -- 假设按钮名为 Unlock

    -- 模拟读取输入内容
    local userPin = mb:GetInputValue("PIN_Input") or ""
    PinUI.validatePin(userPin)
end

-- 校验用户输入的 PIN
function PinUI.validatePin(input)
    if input == PinUI.correctPin then
        Logger.info("PIN correct! Unlocking...")
        State.isLocked = false
        State.failedAttempts = 0
    else
        Logger.info("PIN incorrect")
        State.failedAttempts = (State.failedAttempts or 0) + 1
        if State.failedAttempts >= 5 then
            Logger.info("Too many failed attempts, locking temporarily")
            -- 这里可设置 lockoutUntil 或定时器
        end
    end
end

return PinUI