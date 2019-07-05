local AddOn = NameCopy

BINDING_HEADER_NAMECOPY = "NameCopy Addon"
BINDING_NAME_NAMECOPY_COPY_ITEM = "Copy item to clipboard"

function COPY_ITEM()
    if _G.GameTooltip:NumLines() > 0 then
        local text = _G["GameTooltipTextLeft1"]:GetText()
        local d = {}
        d.text = text
        StaticPopup_Show("ITEM_NAME_NAMECOPY", "", "", d)
    end
end

local function addon_loaded() 
    if NameCopyTooltipTextBool == nil then
        NameCopyTooltipTextBool = true
    else
        _G.GameTooltip:HookScript("OnUpdate", function(self)
            if NameCopyTooltipTextBool and NameCopyTooltipTextBool ~= nil then
                local tooltipNumLines = _G.GameTooltip:NumLines()
                local command, _, _ = GetBindingKey("NAMECOPY")
                local tooltipLine
                if not command then
                    tooltipLine = ""
                else
                    tooltipLine = "Press |cFFFFFF4d" .. command ..
                                      "|r to copy the name"
                end
                if tooltipNumLines > 0 and #tooltipLine > 1 then
                    if (_G["GameTooltipTextLeft" .. tooltipNumLines]:GetText() ~=
                        tooltipLine) then
                        self:AddLine(tooltipLine, 0.56, 0.75, 0.99, 1)
                        self:Show()
                    end
                end
            end
        end)
    end    
end

--save & remove a binding
local function SafeSetBinding(key, action)
    if key == "" then
        local oldkey = _G.GetBindingKey(action)
        if oldkey then
            _G.SetBinding(oldkey, nil)
        end
    else
        _G.SetBinding(key, action)
    end
    _G.SaveBindings(_G.GetCurrentBindingSet())
end

--set a default binding if no one has it
local function SetDefaultBinding(key, action)
    --get our binding
    local ourkey1,ourkey2 = _G.GetBindingKey(action);

    --if we dont have it
    if (ourkey1==nil) and (ourkey2==nil) then

        --get possible action for this binding since CTRL-C or CTRL-SHIFT-C look the same
        local possibleAction = _G.GetBindingByKey(key);

        --by default we could set this binding
        local okToSet = true;

        --if any action
        if possibleAction then

            --get the action keys
            local key1,key2 = _G.GetBindingKey(possibleAction);

            --if any key match our key
            if (key1 == key) or (key2 == key) then
                okToSet = false;
            end

        end

        --if ok to set
        if okToSet then
            SafeSetBinding(key,action);
        end

    end
end

local function entering_world()
    SetDefaultBinding("CTRL-C", "NAMECOPY")
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function eventHandler(_, event, arg1)
    if event == "ADDON_LOADED" then
        if  arg1 == "NameCopy" then
            addon_loaded()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        entering_world()
    end
end

frame:SetScript("OnEvent", eventHandler)

StaticPopupDialogs["ITEM_NAME_NAMECOPY"] =
    {
        text = "Copy the name of the Item/NPC/Object",
        button1 = "Close",
        OnAccept = function() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        OnShow = function(self, data)
            self.editBox:SetText(data.text)
            self.editBox:HighlightText()
        end,
        hasEditBox = true
    }

SLASH_NAMECOPY1 = "/nc"
function SlashCmdList.NAMECOPY(msg)
    NameCopyTooltipTextBool = not NameCopyTooltipTextBool
    if NameCopyTooltipTextBool then
        print("|cFF00FF96NameCopy|r will add a line to tooltips")
    else
        print("|cFF00FF96NameCopy|r won't add a line to tooltips anymore")
    end
end
