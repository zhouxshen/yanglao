
function Disillusion(keys)

	if Illusion_Killer(keys) then return end

    local killed_unit = GetKilledUnit(keys)
	if not killed_unit then return end

    local ability = keys.ability
	local caster = keys.caster
    local kill_debuff = "modifier_fun_disillusion_death"
	local kill_stack_count = ability:GetSpecialValueFor("kill_stack_count")
	local kill_debuff_duration = ability:GetSpecialValueFor("kill_debuff_duration")

	if killed_unit:HasModifier(kill_debuff) then
	    local debuff = killed_unit:FindModifierByName(kill_debuff)
		debuff:ForceRefresh()
		debuff:IncrementStackCount()
        if debuff:GetStackCount() >= kill_stack_count then
			
            killed_unit:Kill(ability, caster)

			if not killed_unit:IsAlive() then
			    local particleName = "particles/econ/items/spectre/spectre_arcana/spectre_arcana_minigame_v2_death_target.vpcf"
		        particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, killed_unit)
		        ParticleManager:SetParticleControl(particle, 0, killed_unit:GetAbsOrigin())
			    ParticleManager:SetParticleControl(particle, 1, killed_unit:GetAbsOrigin())
				killed_unit:EmitSound("Hero_Spectre.ArcanaProgressNormal")
			end
        end
    else
	    local debuff = ability:ApplyDataDrivenModifier(caster, killed_unit, kill_debuff, { duration = kill_debuff_duration })
		debuff:SetStackCount(1)
	end
	return
end

-----------------------------------------------------------------------------------------------------------------------------
--消灭幻象单位,消灭成功返回true，否则是false
function Illusion_Killer(keys)
    
    local killed_unit = GetKilledUnit(keys)

	if killed_unit == nil or killed_unit:IsIllusion() == false then 
	    return false 
	end

	local caster = keys.caster
    
	local particleName = "particles/neutral_fx/miniboss_damage_reflect.vpcf"
    particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), false)
	ParticleManager:SetParticleControlEnt(particle, 1, killed_unit, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), false)
	killed_unit:EmitSound("Miniboss.Tormenter.Target")
	killed_unit:Kill(ability, caster)	 

	return true
end

-----------------------------------------------------------------------------------------------------------------------------
--不是需要消灭的单位就返回nil，否则判断是target、unit还是attacker是需要消灭的单位并返回（消灭对象指幻象或添加死亡标记的单位）
function GetKilledUnit(keys)

    local ability = keys.ability
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target  --OnAttackLanded
	local unit = keys.unit      --OnDealDamage
	local killed_unit 

	if unit then target = unit end

	if caster == attacker then
	    killed_unit = target
	else
	    killed_unit = attacker
	end

	if (not killed_unit:IsHero()) or
	   (not killed_unit:IsAlive()) or
	   (caster:GetTeam() == killed_unit:GetTeam())
	then 
	    return nil
	end

	return killed_unit
end