
function faceless_void_fun_ModifierGainedFilter(event)
    --ʱ�����������Ѿ�Ӣ���ж�
    local caster = EntIndexToHScript(event.entindex_caster_const)
    local npc = EntIndexToHScript(event.entindex_parent_const)
    local modifier_name = event.name_const
    if caster == nil then return true end

    local special_bonus = caster:FindAbilityByName("special_bonus_unique_faceless_void_chronosphere_non_disabled") 
    if special_bonus == nil then return true end
    if special_bonus:GetLevel() < 1 then return true end
    if modifier_name == "modifier_faceless_void_chronosphere_freeze" and
       npc:GetTeam() == caster:GetTeam() and
       npc:IsControllableByAnyPlayer()
    then
       return false
    else
        return true
    end    

end