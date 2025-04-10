require('utils')

function item_fun_grandmasters_glaive_int_OnCreated(keys)
    
    local ability = keys.ability
    local caster = keys.caster

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_aether_lens", nil)
end

function item_fun_grandmasters_glaive_int_OnDestroy(keys)
    
    local ability = keys.ability
    local caster = keys.caster

    local buffs = caster:FindAllModifiersByName("modifier_item_aether_lens")
    for _,v in pairs(buffs) do
        if v:GetAbility() == ability then
            v:Destroy()
            return
        end
    end
end

function item_fun_grandmasters_glaive_int_OnSpellStart(keys)
    
    local ability = keys.ability
    local caster = keys.caster
    local target = keys.target

    if target:TriggerSpellAbsorb(ability) then return end

    if target:IsIllusion() and
       not target:IsStrongIllusion()
    then 
        target:Kill(ability, caster)
        return
    end

    local sheep_duration = ability:GetSpecialValueFor("sheep_duration")
    target:EmitSound("DOTA_Item.Sheepstick.Activate")
    ability:ApplyDataDrivenModifier(caster, target, "modifier_sheepstick_debuff", { duration = sheep_duration })

    return
end

function item_fun_grandmasters_glaive_int_OnAttackStart(keys)
    
    local ability = keys.ability
    local target = keys.target
    local caster = keys.caster
    local modifier_cooldown = "modifier_item_fun_grandmasters_glaive_int_cooldown"
    local modifier_cannot_miss = "modifier_item_fun_grandmasters_glaive_int_cannot_miss"
    local cooldown_duration = ability:GetSpecialValueFor("impact_cooldown")

    caster:RemoveModifierByNameAndCaster(modifier_cannot_miss, caster)
    if caster:HasModifier(modifier_cooldown) or
       caster:IsIllusion() or
       caster:GetTeam() == target:GetTeam() 
    then
        return
    end
    ability:ApplyDataDrivenModifier(caster, caster, modifier_cannot_miss, nil)

    return
end


function item_fun_grandmasters_glaive_int_OnAttackLanded(keys)

    local caster = keys.caster
	local target = keys.target

    if target == nil then return end

	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel() - 1)
    local damage = ability:GetSpecialValueFor("impact_dmg_const") + caster:GetIntellect(false) * ability:GetSpecialValueFor("impact_dmg_int")	
    local slow_time = ability:GetSpecialValueFor("impact_slow_time")
    local modifier_impact_slow = "modifier_item_fun_grandmasters_glaive_int_slow"
    local modifier_cooldown = "modifier_item_fun_grandmasters_glaive_int_cooldown"
    local modifier_cannot_miss = "modifier_item_fun_grandmasters_glaive_int_cannot_miss"
    local cooldown_duration = ability:GetSpecialValueFor("impact_cooldown")

	if caster:HasModifier(modifier_cooldown) or
       not target:IsAlive() or
       not caster:IsAlive() or
       target:IsBuilding() or
       target:IsMagicImmune() or
       caster:GetTeam() == target:GetTeam() or
       caster:IsIllusion()
    then
        return
    end
        
    local particleName = "particles/items_fx/phylactery.vpcf"
    particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)    
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), false)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), false)
    target:EmitSound("Item.Phylactery.Target")

    ability:ApplyDataDrivenModifier(caster, target, modifier_impact_slow, { duration = slow_time })
	ApplyDamage({ victim = target, 
                  attacker = caster, 
                  damage = damage, 
                  damage_type = DAMAGE_TYPE_ABILITY_DEFINED, 
                  --damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
                  ability = ability
                 })
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)        
    ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, { duration = cooldown_duration })
    caster:RemoveModifierByNameAndCaster(modifier_cannot_miss, caster)

    return
end

function item_fun_grandmasters_glaive_int_OnAbilityExecuted(keys)

    local caster = keys.caster
	local ability = keys.ability
    local target = keys.target
    local target_linken = HasSpellAbsorb(keys.target) --HasSpellAbsorb(target),来自utils.lua
    local event_ability = keys.event_ability
     
    --指向性技能被林肯抵挡后不会触发“静电场”和“灵匣”
    if target ~= nil and
       target_linken == nil
    then 
        return 
    end 
    keys.target = target

    if event_ability:IsItem() or
       event_ability:IsToggle() or
       not event_ability:ProcsMagicStick() or
       caster:IsIllusion()
    then
        return
    end
    --[[
    units = FindUnitsInRadius(caster:GetTeam(), 
                              caster:GetAbsOrigin(), 
                              nil, 
                              ability:GetSpecialValueFor("aoe_radius"), 
                              DOTA_UNIT_TARGET_TEAM_ENEMY, 
                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                              DOTA_UNIT_TARGET_FLAG_NONE, 
                              FIND_ANY_ORDER, 
                              false)

	for _,unit in pairs(units) do
 
	    ApplyDamage({ victim = unit, 
                      attacker = caster, 
                      damage = unit:GetHealth() * ability:GetSpecialValueFor("aoe_damage_pct") /100, 
                      damage_type = DAMAGE_TYPE_MAGICAL, 
                      damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
                      ability = ability
                    })	
        local particleName = "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_lock_bash_hit.vpcf"
        local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), false)
    end
    ]]
    item_fun_grandmasters_glaive_int_OnAttackLanded(keys)

end

function item_fun_grandmasters_glaive_int_stack(keys)

	local caster = keys.caster
    local ability = keys.ability
	local stack = math.floor(caster:GetIntellect(false) + 0.5)
    local modifier_name = "modifier_item_fun_grandmasters_glaive_int_spell_amp"

	if true or caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT or caster:HasItemInInventory("item_grandmasters_glaive_three_phase_power") then        
        caster:SetModifierStackCount(modifier_name, caster, stack)
	end
end
