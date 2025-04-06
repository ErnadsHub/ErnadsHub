while task.wait(1) do
  if vci.VoiceChatState ~= Enum.VoiceChatState.Joined and vci.VoiceChatState ~= Enum.VoiceChatState.Joining then
    VoiceChatService:joinVoice()
  end
end
