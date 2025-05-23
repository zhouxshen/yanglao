--所有过滤器在文件'Fun_BaseGameMode/modifier_Fun_BaseGameMode.lua'中注册
require('utils')  --需要用到 is_Human_Team()
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
    --调整AI获取的金钱奖励
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
    --调整AI获取的经验奖励
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
  
    --print("index："..event.entindex_inflictor_const)
    --local inflictor = EntIndexToHScript(event.entindex_inflictor_const)
    --print("ClassName："..inflictor:GetClassname())
    --print("Name："..inflictor:GetName())
    --print(event.damage)

    --***************************************************
    --伤害调整顺序：
    --    精通的法术反制
    --    灵界芒果
    --    獸的特殊防御
    --    阿哈利姆的长袍（暂不加入）
    --***************************************************
    local result = true

    ----------------------------------------------
    --精通的法术反制：antimage_mana_defend
    --文件：fun_heroes/hero_antimage/ant_fashufangzhi.lua
    ----------------------------------------------
    --result = antimage_mana_defend_DamageFilter(event) 

    ----------------------------------------------
    --灵界芒果：item_fun_greater_mango
    --文件：Fun_Items/item_fun_greater_mango.lua
    ----------------------------------------------

    result = item_fun_greater_mango_DamageFilter(event)  

    ---------------------------------------------------
    --獸的特殊防御：Fun_Primal_Beast_Boss_Defense
    --文件：Fun_Boss/Fun_Primal_Beast_Boss_Defense.lua
    ---------------------------------------------------
    --result = Fun_Primal_Beast_Boss_Defense_DamageFilter(event)

    ---------------------------------------------------
    --阿哈利姆的长袍：item_fun_Aghanims_Robe
    --文件：Fun_Items/item_fun_Aghanims_Robe.lua
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
    --獸的特殊防御：Fun_Primal_Beast_Boss_Defense
    ----------------------------------------------
    --result = Fun_Primal_Beast_Boss_Defense_ModifierGainedFilter(event)

    ----------------------------------------------
    --虚空假面的时间结界天赋：special_bonus_unique_faceless_void_chronosphere_non_disabled
    ----------------------------------------------
    result = faceless_void_fun_ModifierGainedFilter(event)]]--

    --将克隆体的福佑A杖BUFF替换为普通版：Fun_BaseGameMode
    --文件：Fun_BaseGameMode/modifier_Fun_BaseGameMode.lua
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
    --獸的特殊防御：Fun_Primal_Beast_Boss_Defense
    --文件：Fun_Boss/Fun_Primal_Beast_Boss_Defense.lua
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
    --莉娜的重破斩：lina_laguna_blade_fun
    --文件：fun_heroes/hero_lina/lina_laguna_blade_fun.lua
    ---------------------------------------------------
    result = lina_laguna_blade_fun_AbilityTuningValueFilter(event)

    ---------------------------------------------------
    --卓尔游侠的银影天仇：drow_ranger_marksmanship_fun
    --文件：fun_heroes/hero_drow_ranger/marksmanship_fun.lua
    ---------------------------------------------------
    result = drow_ranger_marksmanship_fun_AbilityTuningValueFilter(event)

    if type(result) ~= "boolean" then
        result = true
    end
    return result
    ]]--
    return true
end