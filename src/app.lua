local Logger = require("ma3lib.logger")
local UI = require("ma3lib.ui")
local State = require("src.model.state")
local Daemon = require("src.service.daemon")
local Service = require("src.service.action")

local AppObj = {
    actionCalls = 0,
    executeCalls = 0,
    isLocked = true,
    failedAttempts = 0
}

local App = {}


function App.Main(display_handle, argument)
    Logger.info("App.Main called, argument=" .. tostring(argument))

    -- 启动长期服务
    if type(argument)=="string" and argument:lower()=="start" then
        Daemon.start()
        return
    end

    -- 停止服务
    if type(argument)=="string" and argument:lower()=="stop" then
        Daemon.stop()
        return
    end

    -- 查看状态
    if type(argument)=="string" and argument:lower()=="status" then
        State.printStatus(AppObj)
        return
    end

    -- 弹 PIN UI
    if type(argument)=="string" and argument:lower()=="pin" then
        -- 创建 MessageBox
        local mb = UI.showMessageBox(
            "请输入 PIN",
            "请输入数字 PIN：",
            { {name="确认"}, {name="取消"} }
        )

        -- 在 MessageBox 内创建 LineEdit
        local le = UI.createLineEdit(mb, "")

        -- 按钮回调绑定
        mb:SetButtonCallback("确认", function()
            local pin = UI.getLineEditText(le)
            Logger.info("用户输入 PIN: " .. tostring(pin))
            if pin == "1234" then
                Logger.info("PIN 正确，解锁！")
                AppObj.isLocked = false
                AppObj.failedAttempts = 0
            else
                Logger.info("PIN 错误")
                AppObj.failedAttempts = (AppObj.failedAttempts or 0) + 1
                if AppObj.failedAttempts >= 5 then
                    Logger.info("错误次数过多，临时锁定")
                    -- 可以设置 lockout 或定时器
                end
            end
            mb:Hide()
        end)

        mb:SetButtonCallback("取消", function()
            Logger.info("用户取消输入")
            mb:Hide()
        end)

        return
    end

    -- 默认动作（Executor/XKey 或其他命令）
    Service.handleAction(argument, AppObj)
end

-- 清理插件
function App.Cleanup()
    Logger.info("App.Cleanup called")
    Daemon.cleanup()
end

-- 执行事件
function App.Execute(Type, ...)
    Logger.info("App.Execute called, Type=" .. tostring(Type))
    Service.handleExecute(Type, AppObj, ...)
    return nil
end


return App