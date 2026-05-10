local Logger = require("ma3lib.logger")

local UI = {}

-- =========================
-- Overlay 封装
-- =========================
function UI.createOverlay(name)
    local overlay = Display():OverlayCreate("Overlay")
    overlay:SetName(name or "Overlay")
    Logger.info("Overlay created: " .. tostring(name))
    return overlay
end

function UI.showOverlay(overlay)
    overlay:Show()
    Logger.info("Overlay shown: " .. tostring(overlay:GetName()))
end

function UI.hideOverlay(overlay)
    overlay:Hide()
    Logger.info("Overlay hidden: " .. tostring(overlay:GetName()))
end

-- =========================
-- MessageBox 封装
-- =========================
function UI.showMessageBox(title, message, buttons)
    title = title or "Message"
    message = message or ""
    buttons = buttons or { {name="OK", value=1} }

    local mb = Display():OverlayCreate("MessageBox")
    mb:SetTitle(title)
    mb:SetText(message)

    -- 为每个按钮绑定点击回调
    for _, btn in ipairs(buttons) do
        -- 支持 callback
        local callback = btn.callback
        mb:AddButton(btn.name, function()
            Logger.info("Button clicked: " .. btn.name)
            if callback then
                callback()
            end
            mb:Hide()
        end)
    end

    mb:Show()
    Logger.info("MessageBox shown: " .. title)
    return mb
end

-- =========================
-- LineEdit 封装
-- =========================
function UI.createLineEdit(overlay, defaultText)
    local le = overlay:CreateLineEdit()
    le:SetText(defaultText or "")
    le:Focus()
    Logger.info("LineEdit created in overlay: " .. tostring(overlay:GetName()))
    return le
end

function UI.getLineEditText(lineEdit)
    return lineEdit:GetText()
end

function UI.setLineEditText(lineEdit, text)
    lineEdit:SetText(text or "")
end

-- =========================
-- CheckBox 封装
-- =========================
function UI.createCheckBox(overlay, name, checked)
    local cb = overlay:CreateCheckBox()
    cb:SetText(name or "")
    cb:SetState(checked and true or false)
    Logger.info("CheckBox created: " .. tostring(name))
    return cb
end

function UI.getCheckBoxState(cb)
    return cb:GetState()
end

function UI.setCheckBoxState(cb, state)
    cb:SetState(state and true or false)
end

-- =========================
-- Button 封装
-- =========================
function UI.createButton(overlay, name, callback)
    local btn = overlay:CreateButton()
    btn:SetText(name)
    if callback then
        btn:BindClick(callback)
    end
    Logger.info("Button created: " .. tostring(name))
    return btn
end

function UI.clickButton(btn)
    btn:Click()
end

-- =========================
return UI