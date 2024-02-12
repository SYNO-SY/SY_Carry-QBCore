QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('SY_Carry_anim1:server:Sync')
AddEventHandler('SY_Carry_anim1:server:Sync',
	function(target, animationLib, animationLib2, animation, animation2, distans, distans2, height, targetSrc, length,
			 spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
		if target ~= -1 then
			TriggerClientEvent('SY_Carry_anim1:SyncTarget', targetSrc, source, animationLib2, animation2, distans,
				distans2, height, length, spin, controlFlagTarget, animFlagTarget)
		end
	end)

RegisterServerEvent('SY_Carry_anim2:server:Sync')
AddEventHandler('SY_Carry_anim2:server:Sync',
	function(target, animationLib, animation, animation2, distans, distans2, height, targetSrc, length, spin,
			 controlFlagSrc, controlFlagTarget, animFlagTarget)
		if target ~= -1 then
			TriggerClientEvent('SY_Carry_anim2:SyncTarget', targetSrc, source, animationLib, animation2, distans,
				distans2, height, length, spin, controlFlagTarget, animFlagTarget)
			TriggerClientEvent('SY_Carry_anim2:Sync', source, animationLib, animation, length, controlFlagSrc,
				animFlagTarget)
		end
	end)

RegisterServerEvent('SY_Carry:onhandanim')
AddEventHandler('SY_Carry:onhandanim', function(target)
	TriggerClientEvent('SY_Carry:onhandanimcarry', target, source)
end)

RegisterServerEvent('SY_Carry_Anim:stop')
AddEventHandler('SY_Carry_Anim:stop', function(targetSrc)
	TriggerClientEvent('SY_Carry_Anim:client:stop', targetSrc)
end)

---------[REQUEST]---------
RegisterServerEvent("SY_animations:animrequest")
AddEventHandler("SY_animations:animrequest", function(target, reqstcarryanim)
	local revicer = source
	TriggerClientEvent("SY_animations:reciverrequest", target, revicer, reqstcarryanim)
end)

RegisterServerEvent("SY_animations:animationaccepted")
AddEventHandler("SY_animations:animationaccepted", function(target, reqstcarryanim)
	local player2 = source
	TriggerClientEvent("SY_animations:playsharedsource", target, reqstcarryanim, player2)
end)

RegisterServerEvent("SY_animations:animationdenied")
AddEventHandler("SY_animations:animationdenied", function(source)
	Notify("Your Request Has Been Denied", 'error', true, source)
end)
