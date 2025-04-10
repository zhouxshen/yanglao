------------------------------------------------------------------------------

function marksmanship_damage(keys)      --攻击到达时造成伤害
     --if not IsServer() then return end
     local caster = keys.caster  
     local target = keys.target
	 local ability = keys.ability
     local stackCount = caster:GetModifierStackCount("modifier_marksmanship_BUFF", caster)

     if target:IsBuilding() or caster:GetTeam() == target:GetTeam() then   --伤害对建筑或友军无效
         return          
     end

     if stackCount <= 0 then       --层数为0不造成伤害
         return
     end
     if caster:IsIllusion() then return end --幻象不造成伤害

     local Damage = keys.ability:GetSpecialValueFor("damage")

     local damage_table = {}

     damage_table.victim = target
	 damage_table.attacker = caster
	 damage_table.damage = Damage * stackCount
	 damage_table.damage_type = DAMAGE_TYPE_ABILITY_DEFINED  --伤害类型在KV中定义
     damage_table.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
     damage_table.ability = keys.ability          
 
     if caster:HasScepter() then 
         damage_table.damage_flags = damage_table.damage_flags + DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR  --神杖额外伤害无视护甲

		 --******************************************************
         --穿心裂矢
		 --*******************************************************
	     local target_location = target:GetAbsOrigin()		
	     local target_type = ability:GetAbilityTargetType()
	     local target_team = ability:GetAbilityTargetTeam()
	     local target_flags = ability:GetAbilityTargetFlags()

         local radius = ability:GetSpecialValueFor("arrow_range")
	     local max_targets = ability:GetSpecialValueFor("arrow_count")
	     local projectile_speed = ability:GetSpecialValueFor("arrow_speed")
		 local split_shot_projectile = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman.vpcf"
		 local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)
	
	     for _,v in pairs(split_shot_targets) do

		     if v ~= target then

			     local projectile_info = 
			     {
				        EffectName = split_shot_projectile,
				        Ability = ability,
				        vSpawnOrigin = target_location,
				        Target = v,
				        Source = target,
				        bHasFrontalCone = false,
				        bIsAttack = false,
				        bDodgeable = true,
				        iMoveSpeed = projectile_speed,
				        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        bProvidesVision = false
			     }
			     ProjectileManager:CreateTrackingProjectile(projectile_info)
			     max_targets = max_targets - 1
		     end

			 if max_targets == 0 then break end
	     end

     end
     
     SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage_table.damage, nil)  --伤害信息，例如智慧之刃、奥数天球、金箍棒造成的伤害会显示在目标头顶附近
     ApplyDamage(damage_table)

     return
end

------------------------------------------------------------------------------
--新增破坏禁用效果
function isDisabled(keys)

	local ability = keys.ability
	local caster = keys.caster
    local stackCount = caster:GetLevel()+ ability:GetSpecialValueFor("base_stack")

	if caster:PassivesDisabled() or not caster:HasModifier("modifier_drow_ranger_marksmanship_aura_bonus")then 
        if caster:HasModifier("modifier_marksmanship_BUFF") then
	        caster:RemoveModifierByName("modifier_marksmanship_BUFF")
            caster:RemoveModifierByName("modifier_marksmanship_BUFF_fixed")         
        end

	elseif not caster:PassivesDisabled() and caster:HasModifier("modifier_drow_ranger_marksmanship_aura_bonus") then

        if not caster:HasModifier("modifier_marksmanship_BUFF") then
	        ability:ApplyDataDrivenModifier(caster, caster, "modifier_marksmanship_BUFF", nil)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_marksmanship_BUFF_fixed", nil)
        end
        caster:SetModifierStackCount("modifier_marksmanship_BUFF", caster, stackCount)
        caster:SetModifierStackCount("modifier_marksmanship_BUFF_fixed", caster, stackCount)
	end

end

------------------------------------------------------------------------------
--穿心裂矢伤害
function SplitShotDamage(keys)
	
	if not IsServer() then return end
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_pct = ability:GetSpecialValueFor("arrow_dmg") * 0.01
	local damage = caster:GetAverageTrueAttackDamage(nil) * damage_pct
	if not caster:IsRealHero() then
        damage = 0
	end

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.damage = damage 
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL 
	ApplyDamage(damage_table)

end

------------------------------------------------------------------------------
--提升霜冻之箭施法距离
function drow_ranger_marksmanship_fun_AbilityTuningValueFilter(event)

    local caster = EntIndexToHScript(event.entindex_caster_const)
    local ability = EntIndexToHScript(event.entindex_ability_const)
    if ability == nil then return true end

    local fun_ability = caster:FindAbilityByName("drow_ranger_marksmanship_fun") 
	local modifier = caster:FindModifierByName("modifier_marksmanship_BUFF")
    if fun_ability == nil then return true end
    if fun_ability:GetLevel() < 1 then return true end
	if not modifier then return true end
    if ability:GetAbilityName() == "drow_ranger_frost_arrows" and
       event.value_name_const == "AbilityCastRange"
    then
	   local stack = modifier:GetStackCount()
	   local range = stack * fun_ability:GetSpecialValueFor("attack_range_bonus")
	   event.value = event.value + range
       --event.value = math.max(event.value, caster:Script_GetAttackRange())
       return true
    else
        return true
    end

end