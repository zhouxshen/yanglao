--���й��������ļ�'Fun_BaseGameMode/modifier_Fun_BaseGameMode.lua'��ע��
require('utils')  --��Ҫ�õ� is_Human_Team()
require('Fun_Items/item_fun_greater_mango')
--require('Fun_Items/item_fun_Aghanims_Robe')
require('Fun_Boss/Fun_Primal_Beast_Boss_Defense')
require('fun_heroes/hero_lina/lina_laguna_blade_fun')
require('fun_heroes/hero_antimage/ant_fashufangzhi')
require('fun_heroes/hero_drow_ranger/marksmanship_fun')
require('fun_heroes/hero_faceless_void/faceless_void_fun')
require('Fun_BaseGameMode/modifier_Fun_BaseGameMode_Remove_Scepter_Consumed')

--CHeroDemo:ModifyGoldFilter
--CHeroDemo:ModifyExperienceFilter
--CHeroDemo:DamageFilter
--CHeroDemo:ModifierGainedFilter
--CHeroDemo:ExecuteOrderFilter
--CHeroDemo:AbilityTuningValueFilter

--*************************************************************************
--	ModifyGoldFilter
--  *player_id_const
--	*reason_const
--	*reliable
--	*gold
--*************************************************************************

function CHeroDemo:ModifyGoldFilter(event)

    --------------------------------------
    --Fun_BaseGameMode
    --����AI��ȡ�Ľ�Ǯ����
    --------------------------------------

    local difficulty = GameRules.Fun_DataTable["Difficulty"]
    if not is_Human_Team(event.player_id_const) then

        if event.reason_const == DOTA_ModifyGold_CreepKill or 
           event.reason_const == DOTA_ModifyGold_NeutralKill 
        then
            event.gold = event.gold * difficulty
            return true
        end
    end

    return true
end

--*************************************************************************
--	ModifyExperienceFilter
--  *hero_entindex_const
--	*player_id_const
--	*reason_const
--	*experience
--*************************************************************************

function CHeroDemo:ModifyExperienceFilter(event)

    --------------------------------------
    --Fun_BaseGameMode
    --����AI��ȡ�ľ��齱��
    --------------------------------------

    local difficulty = GameRules.Fun_DataTable["Difficulty"]
    if not is_Human_Team(event.player_id_const) then
        if event.reason_const == DOTA_ModifyXP_CreepKill then 
            event.experience = event.experience * difficulty
            return true
        end
    end

    return true
end


--*************************************************************************
--	DamageFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage
--*************************************************************************

function CHeroDemo:DamageFilter(event)
  
    --print("index��"..event.entindex_inflictor_const)
    --local inflictor = EntIndexToHScript(event.entindex_inflictor_const)
    --print("ClassName��"..inflictor:GetClassname())
    --print("Name��"..inflictor:GetName())
    --print(event.damage)

    --***************************************************
    --�˺�����˳��
    --    ��ͨ�ķ�������
    --    ���â��
    --    �F���������
    --    ������ķ�ĳ��ۣ��ݲ����룩
    --***************************************************
    local result = true

    ----------------------------------------------
    --��ͨ�ķ������ƣ�antimage_mana_defend
    --�ļ���fun_heroes/hero_antimage/ant_fashufangzhi.lua
    ----------------------------------------------
    --result = antimage_mana_defend_DamageFilter(event) 

    ----------------------------------------------
    --���â����item_fun_greater_mango
    --�ļ���Fun_Items/item_fun_greater_mango.lua
    ----------------------------------------------

    result = item_fun_greater_mango_DamageFilter(event)  

    ---------------------------------------------------
    --�F�����������Fun_Primal_Beast_Boss_Defense
    --�ļ���Fun_Boss/Fun_Primal_Beast_Boss_Defense.lua
    ---------------------------------------------------
    --result = Fun_Primal_Beast_Boss_Defense_DamageFilter(event)

    ---------------------------------------------------
    --������ķ�ĳ��ۣ�item_fun_Aghanims_Robe
    --�ļ���Fun_Items/item_fun_Aghanims_Robe.lua
    ---------------------------------------------------
    --result = true

    if type(result) ~= "boolean" then
        result = true
    end
    return result
 
end

--*************************************************************************
--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration
--*************************************************************************

function CHeroDemo:ModifierGainedFilter(event)
    
    local result = true
    --[[
    ----------------------------------------------
    --�F�����������Fun_Primal_Beast_Boss_Defense
    ----------------------------------------------
    --result = Fun_Primal_Beast_Boss_Defense_ModifierGainedFilter(event)

    ----------------------------------------------
    --��ռ����ʱ�����츳��special_bonus_unique_faceless_void_chronosphere_non_disabled
    ----------------------------------------------
    result = faceless_void_fun_ModifierGainedFilter(event)]]--

    --����¡��ĸ���A��BUFF�滻Ϊ��ͨ�棺Fun_BaseGameMode
    --�ļ���Fun_BaseGameMode/modifier_Fun_BaseGameMode.lua
    ----------------------------------------------
    result = modifier_Fun_BaseGameMode_Remove_Scepter_Consumed(event, result) 
 
    if type(result) ~= "boolean" then
        result = true
    end
    
    return result
end

--*************************************************************************
--	ExecuteOrderFilter
--  *player_id_const
--	*units: { [string]: EntityIndex }
--	*entindex_target
--	*entindex_ability
--	*issuer_player_id_const
--	*sequence_number_const
--	*queue
--	*order_type
--	*position_x
--	*position_y
--	*position_z
--	*shop_item_name
--*************************************************************************

function CHeroDemo:ExecuteOrderFilter(event)
    --[[
    local result = true 

    ---------------------------------------------------
    --�F�����������Fun_Primal_Beast_Boss_Defense
    --�ļ���Fun_Boss/Fun_Primal_Beast_Boss_Defense.lua
    ---------------------------------------------------
    result = Fun_Primal_Beast_Boss_Defense_ExecuteOrderFilter(event)

    if type(result) ~= "boolean" then
        result = true
    end
    return result
    ]]--
    return true
end

--*************************************************************************
--	AbilityTuningValueFilter
--  *entindex_caster_const
--	*entindex_ability_const
--	*value_name_const
--	*value
--*************************************************************************

function CHeroDemo:AbilityTuningValueFilter(event)
    --[[
    local result = true 
    ---------------------------------------------------
    --���ȵ�����ն��lina_laguna_blade_fun
    --�ļ���fun_heroes/hero_lina/lina_laguna_blade_fun.lua
    ---------------------------------------------------
    result = lina_laguna_blade_fun_AbilityTuningValueFilter(event)

    ---------------------------------------------------
    --׿����������Ӱ���drow_ranger_marksmanship_fun
    --�ļ���fun_heroes/hero_drow_ranger/marksmanship_fun.lua
    ---------------------------------------------------
    result = drow_ranger_marksmanship_fun_AbilityTuningValueFilter(event)

    if type(result) ~= "boolean" then
        result = true
    end
    return result
    ]]--
    return true
end