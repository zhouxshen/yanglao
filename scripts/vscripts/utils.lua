



--��Fun_BaseGameMode/modifier_Fun_BaseGameMode.lua��ʵ�ֹ�
--�жϴ�ID�Ƿ�����������Ӫ
function is_Human_Team(playerID)
    local playerTeam = PlayerResource:GetTeam(playerID)
    return __is_Human_Team(playerTeam)
end

--�жϴ���Ӫ�Ƿ���������Ӫ
function __is_Human_Team(DOTATeam_t)
    if (DOTATeam_t == DOTA_TEAM_GOODGUYS and GameRules.Fun_DataTable["hasHumanPlayer_Radiant"] == true) or
       (DOTATeam_t == DOTA_TEAM_BADGUYS and GameRules.Fun_DataTable["hasHumanPlayer_Dire"] == true)
    then
        return true
    end   
    return false
end




--�ж��Ƿ����ħ��

function Has_Aghanims_Shard(nTarget)

  return  nTarget:HasModifier("modifier_item_aghanims_shard")

end


function Has_ultimate_scepter(nTarget)

  return  nTarget:HasModifier("modifier_item_ultimate_scepter_consumed")

end


--modifier_item_ultimate_scepter

--modifier_item_ultimate_scepter_consumed


function Once_more_nTarget(caster, Once_more_ability ,nTarget )


	local	tether = caster:FindAbilityByName(Once_more_ability)   

	caster:SetCursorCastTarget(nTarget)
					    
	tether:OnSpellStart()
						 
	-- body
end



function Once_more_no_nTarget( caster,Once_more_ability , nTarget_Position )


	local	tether = caster:FindAbilityByName(Once_more_ability)   

	caster:SetCursorPosition(nTarget_Position)
					    
	tether:OnSpellStart()
						 
	-- body
end


--�ж�ָ���Լ����ܷ�������Ŀ��
--���Ŀ�������м��ֵܵ����ԣ�����nil�����򷵻�Ŀ��
--�ѻ��˵�λ��ն����ؽ�����ѻ���
--���ֵܵ���ؼ��ܣ�
--    �ֿϷ���
--    �ֿϷ��򣨵ֵ�ת�ƣ�
--    �񾵶�
--    �������ƣ��з�ʦ��
--    �����ֵ�����ɽ��
--    λ��ն����ѻ��ˣ�
--    �յ�������ɭ����ϼ��

function HasSpellAbsorb(target)
 	
	if target == nil then return nil end

	if target:HasModifier("modifier_item_sphere_target") or
       target:HasModifier("modifier_antimage_counterspell") or
	   target:HasModifier("modifier_hoodwink_decoy_illusion")
	then
	    return nil
	end

	--������ȴЧ���ģ�������д�����û����ؼ��ܣ��ᱨ��luaû����·�жϣ�
	local item_sphere = target:FindItemInInventory("item_sphere")
	local item_mirror_shield = target:FindItemInInventory("item_mirror_shield")
	local ability_roshan_spell_block = target:FindAbilityByName("roshan_spell_block")	
	if item_sphere then
	    if item_sphere:IsCooldownReady() and target:HasModifier("modifier_item_sphere") then
		    return nil
		end
	end
	if item_mirror_shield then
	    if item_mirror_shield:IsCooldownReady() and target:HasModifier("modifier_item_mirror_shield") then
		    return nil
		end
	end
	if ability_roshan_spell_block then
	    if ability_roshan_spell_block:IsCooldownReady() and target:HasModifier("modifier_roshan_spell_block") then
		    return nil
		end
	end

	if target:HasModifier("modifier_spirit_breaker_planar_pocket") then
	    local modifier_temp = target:FindModifierByName("modifier_spirit_breaker_planar_pocket")
		local unit = modifier_temp:GetCaster()
		return HasSpellAbsorb(unit) --�ѻ�������������ֿ���Ҫ�ٴ��ж�
	end
	return target
end