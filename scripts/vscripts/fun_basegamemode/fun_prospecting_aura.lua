--自定义淘金光环
function Fun_Prospecting_Aura_Created(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    target:AddNewModifier(caster, ability, "modifier_special_bonus_gold_income", {})
end

function Fun_Prospecting_Aura_Destroy(keys)
    local caster = keys.caster
    local target = keys.target
    target:RemoveModifierByNameAndCaster("modifier_special_bonus_gold_income", caster)
end