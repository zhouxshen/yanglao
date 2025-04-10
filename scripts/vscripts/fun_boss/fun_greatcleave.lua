
function Fun_GreatCleave(keys)
    
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local distance = ability:GetSpecialValueFor("great_cleave_distance")
    local startRadius = 150
    local endRadius = ability:GetSpecialValueFor("great_cleave_end_radius")
    local damage = ability:GetSpecialValueFor("great_cleave_damage")
    local EffectName = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_2.vpcf"

    DoCleaveAttack(caster, target, ability, damage, startRadius, endRadius, distance, EffectName)

    if true then return end
    ---------------------------------------------------------------------------------------------------------------------------------------
    --[[
    --�����ѹ����ĵ�λ�����м�������δʵ�֣�
    --DOTA_Item.BladeMail.Damage
    local startPos = caster:GetAbsOrigin()
    local endPos = startPos + distance * caster:GetForwardVector():Normalized()
    local teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
    local typeFilter = DOTA_UNIT_TARGET_HERO
    local flagFilter = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE

    local units = FindUnitsInLine(caster:GetTeam(), startPos, endPos, target, endRadius, teamFilter, typeFilter, flagFilter)
    
    for i,unit in ipairs(units) do
       
    end
    ]]--
    return
end