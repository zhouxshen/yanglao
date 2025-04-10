
function MoveUnits( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	ability.point_entity = target

	local speed = ability:GetLevelSpecialValueFor("pull_speed", ability_level)/33
	local radius = ability:GetLevelSpecialValueFor("far_radius", ability_level)


	local target_teams = ability:GetAbilityTargetTeam() 
	local target_types = ability:GetAbilityTargetType() 
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES --ability:GetAbilityTargetFlags() 


	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)

	for i,unit in ipairs(units) do

	--�Ƚ����ߣ��̶��򾶱仯����speed�����
	local unit_location = unit:GetAbsOrigin()
	local vector_distance = unit_location - target_location
	local distance = vector_distance:Length2D()
	local a = distance
	--local b = math.rad(168.75)    --�Ƚ����ߵļнǣ���ǣ���Ƕ�11.25�й�,��ʱ����תʱ�����Ŀ���
	--local cot_b = 1/math.tan(b)   --����
	--local sec_b = 1/math.cos(b)  --����
    local rho = a - speed  --��ת�̶��������򾶳��ȣ�����ϣ��rho��aС������sec_bΪ��
	local rad = math.log(rho /a) /(-0.6127) --�򾶶�Ӧ�ļ���,�����ǻƽ����߲���������

	local x1 = unit_location.x
	local y1 = unit_location.y
	local x2 = target_location.x
	local y2 = target_location.y
	unit_location.x = (x1 - x2) * math.cos(rad) - (y1 - y2) * math.sin(rad) + x2
	unit_location.y = (x1 - x2) * math.sin(rad) + (y1 - y2) * math.cos(rad) + y2

	local vector_distance_new = unit_location - target_location
	local direction = vector_distance_new:Normalized()

	if distance > speed then
		unit:SetAbsOrigin(target_location + direction * rho)
	else
		unit:SetAbsOrigin(target_location)
	end

	--[[
	--�Ƚ����ߣ���ת�̶�������������нǹ̶�Ϊ��180 - 11.25 = 168.75��,ÿ�뻡��Լ33��ÿ��tick����Ϊ1
	local unit_location = unit:GetAbsOrigin()
	local vector_distance = unit_location - target_location
	local distance = vector_distance:Length2D()

	local a = distance
	local b = math.rad(168.75)    --�Ƚ����ߵļнǣ���ǣ���Ƕ�11.25�й�,��ʱ����תʱ�����Ŀ���
	local cot_b = 1/math.tan(b)   --����
	local sec_b = 1/math.cos(b)  --����
    local rho = speed /sec_b + a  --��ת�̶��������򾶳��ȣ�����ϣ��rho��aС������sec_bΪ��
	local rad = math.log(rho /a) /cot_b --�򾶶�Ӧ�ļ��ǣ�����ǰһ��Ϊ��������cot_bҲΪ����rad�ĵ�λ�ǻ���

	--��ת�Ƕ�Ϊrad
	local x1 = unit_location.x
	local y1 = unit_location.y
	local x2 = target_location.x
	local y2 = target_location.y
	unit_location.x = (x1 - x2) * math.cos(rad) - (y1 - y2) * math.sin(rad) + x2
	unit_location.y = (x1 - x2) * math.sin(rad) + (y1 - y2) * math.cos(rad) + y2

	local vector_distance_new = unit_location - target_location
	local direction = vector_distance_new:Normalized()
	unit:SetAbsOrigin(target_location + direction * rho)
	]]--

	--[[
	    --�Ƚ����ߣ��̶���ת�Ƕȵ����������Ҫ����speed��ÿ��tick��ת0.52��
		local unit_location = unit:GetAbsOrigin()
		--��һ������Ŀ�����������ת�����ʵĽǶ�
		local x1 = unit_location.x
		local y1 = unit_location.y
		local x2 = target_location.x
		local y2 = target_location.y
		unit_location.x = (x1 - x2) * math.cos(math.rad(0.52)) - (y1 - y2) * math.sin(math.rad(0.52)) + x2                   --math.sin(math.rad(11.25))     math.cos(math.rad(11.25))
		unit_location.y = (x1 - x2) * math.sin(math.rad(0.52)) + (y1 - y2) * math.cos(math.rad(0.52)) + y2
		
		--�ڶ�����������ת�Ƕȣ�����Ƚ������������ĵľ���
		local vector_distance = unit_location - target_location 
		--local vector_distance = target_location - unit_location
		local distance = vector_distance:Length2D()
		--�Ƚ����߲�����a���������м���=0�ĳ�ʼλ�ã�b��쳲��������ߵĲ���
		--����˳ʱ����ת�����ǣ��󣬻�������λ�ÿ���
		a = distance
        b = 0.3063489
		--�ѣ�����rho,��ʾ�������ĵĳ���
		rho = a * math.exp(math.rad(-0.52) * b ) 

		local direction = vector_distance:Normalized()
		unit:SetAbsOrigin(target_location + direction * rho)
    }}--
		--[[
		if distance > speed then
			unit:SetAbsOrigin(unit_location + direction * speed)
		else
			unit:SetAbsOrigin(unit_location + direction * distance)
		end
		]]--
	end
end

function ChannelEnd(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	if ability.point_entity:IsNull() == false then
		ability.point_entity:RemoveModifierByName("modifier_black_hole_datadriven")
		--StopSoundOn("Hero_Enigma.Black_Hole", caster)
	end
	StopSoundOn("Hero_Enigma.Black_Hole", caster)
end


function GiveVision(keys)
	caster = keys.caster
	ability = keys.ability
	local targetPoint = keys.target_points[1]
	local vision_radius = ability:GetLevelSpecialValueFor( "vision_radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local tether = caster:FindAbilityByName("enigma_midnight_pulse")
	local immune_duration = ability:GetLevelSpecialValueFor( "immune_duration", ability:GetLevel() - 1 )
	AddFOWViewer(caster:GetTeam(), ability:GetCursorPosition(), vision_radius, duration, false)

 	if caster:HasScepter() then
		caster:AddNewModifier(caster, ability, "modifier_elder_titan_echo_stomp_magic_immune", { duration = immune_duration })
	end

 	if caster:HasModifier("modifier_item_aghanims_shard") and tether then
	    if tether:GetLevel() >=1 then
		    caster:SetCursorPosition(targetPoint)
		    tether:OnSpellStart()
		end
	end
end
