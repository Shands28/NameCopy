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

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
local function eventHandler(event, arg1)
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
