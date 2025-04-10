
function fashufangzhi(keys)

	local ability = keys.ability
	local caster = keys.caster
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)* caster:GetCooldownReduction()
	local time = ability:GetSpecialValueFor("持续时间")
	local attacker = keys.attacker

	if caster:PassivesDisabled() then return end 

	if ability:IsCooldownReady() then

		if attacker:IsHero() then
		    
            local removeStuns = false
			local removeExceptions = false

			if caster:HasModifier("modifier_item_aghanims_shard") then
			    removeStuns = true
				removeExceptions = true
			end

		    caster:Purge(false, true, false, removeStuns, removeExceptions)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_antimage_counterspell", {duration = time })

			if caster:HasScepter() then
			    caster:PerformAttack(attacker, true, true, true, true, false, false, true)
				local ulti = caster:FindAbilityByName("antimage_mana_void")
				if ulti then
				    caster:SetCursorCastTarget(attacker)
                    ulti:OnSpellStart()
				end
			end

			ability:StartCooldown(cooldown)
		end
	end
end

function antimage_mana_defend_DamageFilter(event)
    if event.entindex_victim_const == nil or
	   event.entindex_attacker_const == nil 
	then
	    return true
	end
    local victim = EntIndexToHScript(event.entindex_victim_const)
	local attacker = EntIndexToHScript(event.entindex_attacker_const)
	local fun_ability = attacker:FindAbilityByName("antimage_mana_defend")
	if fun_ability == nil then return true end
	if victim:HasModifier("modifier_antimage_mana_break_slow") and
       fun_ability:GetLevel() >= 1 and
	   attacker:HasScepter()
	then
	    local pre_dmg = event.damage
		local resistance = 0
		if event.damagetype_const == DAMAGE_TYPE_MAGICAL then
		    resistance = victim:Script_GetMagicalArmorValue(false, nil)
		elseif event.damagetype_const == DAMAGE_TYPE_PHYSICAL then
		    local armor = victim:GetPhysicalArmorValue(false)
		    resistance = 0.06 * armor/(1 + 0.06 * armor)
		end
		if resistance >= 1 then return true end
		event.damage = pre_dmg / (1 - resistance)
	    --event.damagetype_const = DAMAGE_TYPE_PURE
		return true
	end
	return true
end
