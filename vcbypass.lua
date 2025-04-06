local Players = game:GetService('Players')
local VoiceChatService = game:GetService('VoiceChatService')
local key = game:GetService("UserInputService")
local vci = game:GetService("VoiceChatInternal")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/main/UI-Libraries/Bloom/UI.lua"))()

local LocalPlayer = Players.LocalPlayer
local wl = false
local AutoBypass = false
local fakeSuspend = false

local Main = Library:Create("Ernads VC Bypasser")
local TabH = Main.MakeTab("Ernads VC Bypasser - Welcome, "..LocalPlayer.Name, 6023426922)


local Sections = {
    ['Home'] = {
        Bypass = TabH.MakeSection("Bypass"),
    }
}

local Bypass = Sections.Home.Bypass

Bypass.Button("Unsuspend VC", function()
	VoiceChatService:joinVoice()
	fakeSuspend = false
end)

Bypass.Button("Fake Suspension", function()
	vci:Leave()
	fakeSuspend = true
end)

Bypass.Toggle("Auto Unban", false, function(Bool)
	AutoBypass = Bool
end)

Bypass.Label("Made by Keozog on Discord.")
