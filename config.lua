Config = {}

Config = {
    Time        = 0.3,
    command     = 'carry',
    acceptkey   = 246 ,
    declinekey  = 182 ,
    requestmessage = "Y to accept, L to refuse",  -- Request message (Note you can change the style of the message according to your Notification properties.)
}

-- Notification system (you can add your )
Notify = function(text,msgtype,IsServer,src)
    if IsServer then
        TriggerClientEvent('SY_Notify:Alert', source, "CARRY", text, 5000, msgtype )  -- Server side Notification.(Note you can use any notification system here)
        --TriggerClientEvent('okokNotify:Alert', source, "CARRY", text, 5000, msgtype )
    else                                                     
        exports['SY_Notify']:Alert("Carry", text, 5000, msgtype)  -- Client side Notification.(Note you can use any notification system here)
        --exports['okokNotify']:Alert("Carry", text, 5000, msgtype)
    end
end