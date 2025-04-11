
require('timers')

blessing_table = {
	--1
    {   modifier = "modifier_hero_blessing_fun_all attributes",                name_cn = "+18全属性"          },
	--2
	-- {   modifier = "modifier_hero_blessing_bonus_gold",                        name_cn = "+500金钱"          },
	-- {   modifier = "modifier_hero_blessing_bonus_status_resistance_z",           name_cn = "+100%状态抗性"      },
	{   modifier = "modifier_hero_blessing_bonus_attackspeed_constant",        name_cn = "+80攻击速度"      },
	{   modifier = "modifier_hero_blessing_bonus_attack_range",           	   name_cn = "+120攻击距离"      },
	{   modifier = "modifier_hero_blessing_bonus_attack_combine",              name_cn = "绝世武神"      },
	{   modifier = "modifier_hero_blessing_bonus_magic_combine",               name_cn = "有法可依"      },
	{   modifier = "modifier_hero_blessing_bonus_meat_shield_combine",         name_cn = "一夫当关"      },
	{   modifier = "modifier_hero_blessing_bonus_base_combine",                name_cn = "万丈高楼"      },
	{   modifier = "modifier_hero_blessing_bonus_base_combine",                name_cn = "时光尽头"      },
	-- {   modifier = "modifier_hero_blessing_bonus_cast_range",                  name_cn = "+280施法距离"      },
	--3
	{   modifier = "modifier_hero_blessing_bonus_respawn",                     name_cn = "-100秒复活时间"      },
	--4
	{   modifier = "modifier_hero_blessing_bonus_movespeed",                   name_cn = "+85移动速度"        },
	--5
	{   modifier = "modifier_hero_blessing_bonus_damage",                      name_cn = "+50额外攻击力"      },
	--6
	{   modifier = "modifier_hero_blessing_bonus_damage_percent",              name_cn = "+35%基础攻击力"     },
	--7
	{   modifier = "modifier_hero_blessing_bonus_mana_cost_percent",           name_cn = "-35%魔法消耗"       },
	--8
	{   modifier = "modifier_hero_blessing_bonus_spell_amplify_percent",       name_cn = "+25%技能增强"       },
	--9
	{   modifier = "modifier_hero_blessing_bonus_cooldown_percent",            name_cn = "+25%冷却时间减少"   },
	--10
	{   modifier = "modifier_hero_blessing_bonus_incoming_spell_percent",      name_cn = "+55%魔法抗性"       },
	--11
	{   modifier = "modifier_hero_blessing_bonus_armor",                       name_cn = "+24护甲"          },
	--12
	{   modifier = "modifier_hero_blessing_bonus_incoming_damage_percent",     name_cn = "-30%受到的伤害"     },
    --13
	-- {   modifier = "modifier_hero_blessing_bonus_vision",                      name_cn = "+100%状态抗性"      },
	--14
	{   modifier = "modifier_hero_blessing_bonus_health_regen",                name_cn = "+35生命恢复"      },
	--15
	{   modifier = "modifier_hero_blessing_bonus_mana_regen",                  name_cn = "+15魔法恢复"      }
}

items_table = {
	--1
    {   item = "item_recipe_fun_Aghanims_Robe",                                name_cn = "阿哈利姆的长袍"          },
	--2
	{   item = "item_recipe_fun_Aghanims_Fake_Scepter",                        name_cn = "阿哈利姆的赝品"          },
	--3
	{   item = "item_recipe_fun_greater_mango",                                name_cn = "灵界芒果"                },
	--4
	{   item = "item_recipe_fun_Mercurys_gloves",                              name_cn = "墨丘利的护手"            },
	--5
	{   item = "item_recipe_fun_monkey_king_bar",                              name_cn = "定海神针"                },
	--6
	{   item = "item_recipe_fun_super_blink_dagger",                           name_cn = "科勒的超级匕首"          },
	--7
	{   item = "item_recipe_fun_grandmasters_glaive_str",                      name_cn = "大师之笛-力量"           },
	--8
	{   item = "item_recipe_fun_grandmasters_glaive_agi",                      name_cn = "大师之笛-敏捷"           },
	--9
	{   item = "item_recipe_fun_grandmasters_glaive_int",                      name_cn = "大师之笛-智力"           },
	--10
	{   item = "item_recipe_bfury_v2",                                         name_cn = "上古狂战斧"              },
	--11
	{   item = "item_recipe_desolator_v2",                                     name_cn = "上古黯灭"                },
	--12
	{   item = "item_recipe_greater_crit_v2",                                  name_cn = "伊卡洛斯之殇"            },
    --13
	{   item = "item_recipe_fun_trident_three_phase_power",                    name_cn = "破泞之主的疏浚三叉戟"    },
	--14
	{   item = "item_recipe_fun_Jade_boots",                                   name_cn = "翡翠鞋"                  },
	--15
	{   item = "item_recipe_fun_shivas_guard_v2",                              name_cn = "冰霜重铠"                },
	--16
	{   item = "item_recipe_fun_lotus_orb_v2",                                 name_cn = "宝莲玄珠"                },
	--17
	{   item = "item_recipe_fun_spirit_vessel",                                name_cn = "锢魂法器"                },
	--18
	{   item = "item_recipe_fun_assault_armor_v2",                             name_cn = "强袭战甲"                },
	--19
	{   item = "item_recipe_fun_pipe_v2",                                      name_cn = "德尊烟斗"                },
}

function item_fun_blessing( keys )
    if not IsServer() then return true end
	local target = keys.caster
	local self_ability = keys.ability      --这个才是祝福物品
	local reset_times = self_ability:GetSpecialValueFor("reset_times")    --取消重置次数后，这个变量代表额外可选项，值为2代表3选1
    local ability = GameRules.Fun_DataTable["GameModeAbility"]
	local caster = keys.caster
	
	if ability == nil or not target:IsRealHero() then return end

	math.randomseed(Time()*FrameTime())

	if target.blessing_table == nil then
		
	    target.blessing_table = {}	
		target.blessing_table["optional_buff"] = {}
		target.blessing_table["optional_recipe"] = {}

		for i = 1, math.max(#blessing_table, #items_table) do
		    if i <= #blessing_table then
		        target.blessing_table["optional_buff"][i] = i
			end
		    if i <= #items_table then
		        target.blessing_table["optional_recipe"][i] = i
			end			
		end

		if GameRules.isDemo == false then

	        for i = 1, math.max(#blessing_table, #items_table) - reset_times - 1 do

                local rand_1 = 0 
                local rand_2 = 0 

	            if i <= #blessing_table - reset_times - 1 then
		            rand_1 = RandomInt(1,#target.blessing_table["optional_buff"])
			        table.remove(target.blessing_table["optional_buff"], rand_1)
		        end

		        if i <= #items_table - reset_times - 1 then
		            rand_2 = RandomInt(1,#target.blessing_table["optional_recipe"])
			        table.remove(target.blessing_table["optional_recipe"], rand_2)
		        end
	        end
		end

		target.blessing_table["times"] = -1
		target.blessing_table["buff"] = ""
		target.blessing_table["recipe"] = ""
	end
	
	--发放buff和卷轴
	--1、未获取祝福时，任何时刻都可以获取祝福
	--2、比赛开始前可以任意更换提供的祝福效果和卷轴，发放的金钱和卷轴回收失败则无法更换
	--3、斧王岛不限制可选项，每次使用都会更换成新的效果

    local index_1 = -1 
	local index_2 = -1
	local temp_str_buff = PlayerResource:GetPlayerName(target:GetPlayerID()).."获得祝福："
	local temp_str_recipe = PlayerResource:GetPlayerName(target:GetPlayerID()).."获得物品卷轴："
	local buff = target:FindModifierByName(target.blessing_table["buff"])
    local recipe = target:FindItemInInventory(target.blessing_table["recipe"])

    if GameRules.isDemo == true then

	    --斧王岛不限制可选项，每次使用都是新的效果
		--依然会回收卷轴，但不会因为金钱不足或者无法回收卷轴而失败
		target.blessing_table["times"] = target.blessing_table["times"] + 1
	    index_1 = target.blessing_table["times"] % #blessing_table + 1
		index_2 = target.blessing_table["times"] % #items_table + 1

		if buff then 
		    buff:Destroy()
		end

		if recipe then
		    recipe:Destroy()
		end

		ability:ApplyDataDrivenModifier(caster, target, blessing_table[index_1].modifier, {})
		target.blessing_table["buff"] = blessing_table[index_1].modifier

		target:AddItemByName(items_table[index_2].item)
		target.blessing_table["recipe"] = items_table[index_2].item		

		temp_str_buff = temp_str_buff.."<font color=\"#00FF00\">"..blessing_table[index_1].name_cn.."</font> "
		temp_str_recipe = temp_str_recipe.."<font color=\"#00FF00\">"..items_table[index_2].name_cn.."</font> "

	else
		--对战地图内只能从随机的几项选择一项，出兵前可以随意更换
		--没有祝福效果的情况下，出兵后只能使用一次
	    
	    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or 
		   (GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and target.blessing_table["times"] == -1)
		then
		    
			--回收额外金钱
		    local gold = ability:GetSpecialValueFor("bonus_gold")
	        if target.blessing_table["buff"] == "modifier_hero_blessing_bonus_gold" and target:GetGold() >= gold then
		        target:ModifyGold(-1 * gold, false, DOTA_ModifyGold_AbilityGold)
			elseif target.blessing_table["buff"] == "modifier_hero_blessing_bonus_gold" and target:GetGold() < gold then
			    GameRules:SendCustomMessage(PlayerResource:GetPlayerName(target:GetPlayerID()).. " : " .."<font color=\"#FFD700\">重置祝福失败，金钱不足。</font> ", DOTA_TEAM_BADGUYS,0)
				return
		    end

			--回收物品卷轴
			if target.blessing_table["recipe"] ~= "" and recipe == nil then 
		        GameRules:SendCustomMessage(PlayerResource:GetPlayerName(target:GetPlayerID()).. " : " .."<font color=\"#FFD700\">重置祝福失败，未能回收卷轴。</font> ", DOTA_TEAM_BADGUYS,0)
				return
			end

			target.blessing_table["times"] = (target.blessing_table["times"] + 1) % (reset_times + 1)
		    index_1 = target.blessing_table["optional_buff"][target.blessing_table["times"]+1]
		    index_2 = target.blessing_table["optional_recipe"][target.blessing_table["times"]+1]

    		if buff then	
			    buff:Destroy()
			end

			if recipe then
				recipe:Destroy()
            end

		    ability:ApplyDataDrivenModifier(caster, target, blessing_table[index_1].modifier, {})
		    target.blessing_table["buff"] = blessing_table[index_1].modifier

		    target:AddItemByName(items_table[index_2].item)
		    target.blessing_table["recipe"] = items_table[index_2].item		

			--发送祝福的激活情况
		    for i = 1, reset_times + 1 do
			    if i == target.blessing_table["times"] + 1 then
				    temp_str_buff = temp_str_buff.."<font color=\"#00FF00\">"..blessing_table[index_1].name_cn.."（已激活）</font> "
					temp_str_recipe = temp_str_recipe.."<font color=\"#00FF00\">"..items_table[index_2].name_cn.."（已激活）</font> "
				else
				    local temp_index_1 = target.blessing_table["optional_buff"][i]
					local temp_index_2 = target.blessing_table["optional_recipe"][i]
				    temp_str_buff = temp_str_buff.."<font color=\"#FF0000\">"..blessing_table[temp_index_1].name_cn.."（未激活）</font> "
					temp_str_recipe = temp_str_recipe.."<font color=\"#FF0000\">"..items_table[temp_index_2].name_cn.."（未激活）</font> "
                end
				if i ~= reset_times + 1 then
				    temp_str_buff = temp_str_buff.." "
					temp_str_recipe = temp_str_recipe.." "
				end
			end

		else
		    --没有祝福效果的情况下，出兵后只能使用一次
			GameRules:SendCustomMessage(PlayerResource:GetPlayerName(target:GetPlayerID()).. " : " .."<font color=\"#FFD700\">重置祝福失败，已开始游戏。</font> ", DOTA_TEAM_BADGUYS,0)
			return	    
		end	  

	end

	GameRules:SendCustomMessage(temp_str_buff, DOTA_TEAM_BADGUYS,0)
	GameRules:SendCustomMessage(temp_str_recipe, DOTA_TEAM_BADGUYS,0)

end

function modifier_hero_blessing_bonus_mana_cost_percent_OnCreated(keys)

    local target = keys.target
    local ability = GameRules.Fun_DataTable["GameModeAbility"]
	local caster = keys.caster
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_special_bonus_mana_reduction", {})

end

function modifier_hero_blessing_bonus_mana_cost_percent_OnDestroy(keys)

    local target = keys.target
	local buff_table = target:FindAllModifiersByName("modifier_special_bonus_mana_reduction")
    for _,v in pairs(buff_table) do 
	    if v:GetAbility() == GameRules.Fun_DataTable["GameModeAbility"] then
		    v:Destroy()
			return
		end
	end
end

