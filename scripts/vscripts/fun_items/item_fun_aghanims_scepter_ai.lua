require('Fun_BaseGameMode/modifier_Fun_BaseGameMode')

--添加修饰器
function modifier_item_fun_Aghanims_Scepter_AI_OnCreated(keys)

	local ability = keys.ability
	local caster = keys.caster
	local c_team = caster:GetTeam()

	--__is_Human_Team(t_Team)来自文件modifier_Fun_BaseGameMode.lua
	if __is_Human_Team(c_team) then return end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fun_Aghanims_Scepter_AI_buff", {})
	if caster:GetPrimaryAttribute() == 2 then
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fun_Aghanims_Scepter_AI_buff_intellent", {})
	end				
end

---------------------------------------------------------------------------------------------------------------------------------
--移除修饰器
function modifier_item_fun_Aghanims_Scepter_AI_OnDestroy(keys)

    local caster = keys.caster
	caster:RemoveModifierByNameAndCaster("modifier_item_fun_Aghanims_Scepter_AI_buff", caster)
	caster:RemoveModifierByNameAndCaster("modifier_item_fun_Aghanims_Scepter_AI_buff_intellent", caster)
end

---------------------------------------------------------------------------------------------------------------------------------
--无限买活
function modifier_item_fun_Aghanims_Scepter_AI_OnDeath(keys)

	local caster = keys.caster
	local c_team = caster:GetTeam()  
	
	--__is_Human_Team(t_Team)来自文件modifier_Fun_BaseGameMode.lua
	if __is_Human_Team(c_team) then return end	

	caster:SetBuybackCooldownTime(0)

end