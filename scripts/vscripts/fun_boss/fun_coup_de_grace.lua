
function OnAttackStart(keys)

    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifier_crit = keys.modifier_crit
    local chance = ability:GetSpecialValueFor("crit_chance")
  
    if caster:HasModifier(modifier_crit) then
        caster:RemoveModifierByName(modifier_crit)
    end

    if target:IsBuilding() or target:GetTeam() == caster:GetTeam() then return end

    local r = RollPseudoRandomPercentage(chance, DOTA_PSEUDO_RANDOM_PHANTOMASSASSIN_CRIT, caster)
    if r then
        ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, nil)
    end

    return
end

--------------------------------------------------------------------------------------------------------

function OnAttackLanded(keys)

    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
    local dam_duration = ability:GetSpecialValueFor("dam_duration")
    local modifier_crit = keys.modifier_crit
    local modifier_dam = keys.modifier_dam
    local modifier_stack = keys.modifier_stack

    if not caster:HasModifier(modifier_crit) then 
        return 
    end

    if target:IsBuilding() or target:GetTeam() == caster:GetTeam() then 
        return 
    end

    if not target:IsMagicImmune() and target:IsHero() then
        ability:ApplyDataDrivenModifier(caster, target, modifier_stack, { duration = debuff_duration })
    end
    ability:ApplyDataDrivenModifier(caster, caster, modifier_dam, { duration = dam_duration })

    target:EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")--依靠LUA升级的技能无法加载声音，需要其他技能预载入
    --local particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf"
    local particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_r.vpcf"
    local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), false)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlTransformForward(particle, 0, target:GetAbsOrigin(), -1 * caster:GetForwardVector())  --特效的方向存在小BUG，远程攻击者的特效与弹道方向有关，与自身朝向无关  
    ParticleManager:SetParticleControlTransformForward(particle, 1, target:GetAbsOrigin(), -1 * caster:GetForwardVector())  --目前出窍的灵魂朝向固定在东边

    return
end

--------------------------------------------------------------------------------------------------------

function Stack_Increase(keys)

    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifier_debuff = keys.modifier_debuff
    local debuff_duration = ability:GetSpecialValueFor("debuff_duration")   

    if not target:HasModifier(modifier_debuff) then
        local debuff = ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, { duration = debuff_duration })
        debuff:SetStackCount(1)
    else
        local debuff = target:FindModifierByName(modifier_debuff)
        debuff:IncrementStackCount()
        debuff:ForceRefresh()
    end

    return
end

--------------------------------------------------------------------------------------------------------

function Stack_Decrease(keys)

    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifier_debuff = keys.modifier_debuff
    local debuff = target:FindModifierByName(modifier_debuff)

    if debuff and debuff:GetStackCount() <= 1 then
        target:RemoveModifierByName(modifier_debuff)
    elseif debuff then
        debuff:DecrementStackCount()
    end

    return
end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------



