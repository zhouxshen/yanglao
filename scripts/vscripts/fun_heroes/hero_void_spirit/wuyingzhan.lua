require('timers')

function wuyingzhan( keys )

	local ability = keys.ability
	local caster = keys.caster
    local target = keys.target
	local num = ability:GetSpecialValueFor("num")
	local tick = ability:GetSpecialValueFor("tick")
	if target:TriggerSpellAbsorb(ability) then return end
	local hasUlti = true
	local tether
	--记录斩击次数，变为局部变量，防止拉比克与虚无之灵共享次数
	local v = nil
	local bb = nil
	local g = nil

	local buff = ability:ApplyDataDrivenModifier(caster, caster, "modifier_void_spirit_wudizhan", {})
	local debuff = ability:ApplyDataDrivenModifier(caster, target, "modifier_void_spirit_wudizhan_true_sight", {})

    local fruits = {}
    for i=1,num do
        a = math.floor(math.random (1,360))
		table.insert(fruits,a)
	end

	--******************************************************************
    --生效阶段
    --******************************************************************
    Timers:CreateTimer(function()
		
        local targetPoint = target:GetOrigin()
		local casterPoint = caster:GetOrigin()
		local weizhixiangliang = targetPoint - casterPoint
		local distance = weizhixiangliang:Length2D()
		local direction = weizhixiangliang:Normalized()
		local vecShip0 = direction
		 
	    --------------------------------------------------------------------
		--阵亡、失去视野、超出极限距离2000后终止技能
		--------------------------------------------------------------------
	    if not (caster:IsAlive() and target:IsAlive()) or target:IsInvisible()  or distance > 2000 then 
		    buff:SetDuration(0.1, true)
			debuff:SetDuration(0.1, true)
			GridNav:DestroyTreesAroundPoint(end_vec, 350, true)
			v = nil
			bb = nil
			if hasUlti == false then
	            caster:RemoveAbility("void_spirit_astral_step")
	        end
			--print("终止原因：失效单位")
			return nil
		end

		if v == nil then
		    v  = 1
	    elseif v <= #fruits then
		    v = v + 1
	    else
		    v = 1
	    end

		tether = caster:FindAbilityByName("void_spirit_astral_step")
	    --------------------------------------------------------------------
		--未拥有此技能时，技能等级取决于自身
		--------------------------------------------------------------------
		if tether == nil then
		    tether = caster:AddAbility("void_spirit_astral_step")
			if caster:GetLevel() >= 18 then
			    tether:SetLevel(3)
			elseif caster:GetLevel() >= 12 then
			    tether:SetLevel(2)
			elseif caster:GetLevel() >= 6 then
			    tether:SetLevel(1)
			end
			tether:SetHidden(true)
			hasUlti = false
		end

		--斩击的起始、终点与太虚之径的最大距离相关,上限1200。下限200，否则等级过低/未学习时会出现0向量导致模型动作错误。
		local travel = math.max(200,(tether:GetSpecialValueFor("max_travel_distance") + caster:GetCastRangeBonus())/2)  
		travel = math.min(travel , 1200)

		--目标点
		local x1 = targetPoint.x + travel * ( vecShip0.x * math.cos(math.rad(fruits[v])) - vecShip0.y * math.sin(math.rad(fruits[v])) )  
		local y1 = targetPoint.y + travel * ( vecShip0.y * math.cos(math.rad(fruits[v])) + vecShip0.x * math.sin(math.rad(fruits[v])) )  

		--起始点
		local x2 = targetPoint.x + travel * ( vecShip0.x * math.cos(math.rad(fruits[v]+180)) - vecShip0.y * math.sin(math.rad(fruits[v]+180)) )  
		local y2 = targetPoint.y + travel * ( vecShip0.y * math.cos(math.rad(fruits[v]+180)) + vecShip0.x * math.sin(math.rad(fruits[v]+180)) )  

		local start_vec = Vector(x2,y2,targetPoint.z)
		local end_vec = Vector(x1,y1,targetPoint.z)

		FindClearSpaceForUnit(caster, start_vec, true)
		CenterCameraOnUnit(caster:GetPlayerID(), target)
		AddFOWViewer(caster:GetTeam(), targetPoint, 800, 1.5, false)

		caster:SetForwardVector(TG_Direction(end_vec, start_vec))
		caster:SetCursorPosition(end_vec)
		tether:OnSpellStart()       
        if bb == nil then
            bb =0
		end
				     
		bb = bb + 1
		g = bb +1

	    --------------------------------------------------------------------
		--次数达到上限终止技能
		--------------------------------------------------------------------
		if g > #fruits then
		    bb = nil
			v = nil
            buff:SetDuration(0.1, true)
			debuff:SetDuration(0.1, true)
			GridNav:DestroyTreesAroundPoint(end_vec, 350, true)
			--print("终止原因：次数上限")
			if hasUlti == false then
	            caster:RemoveAbility("void_spirit_astral_step")
	        end
            return nil
		else									 
			return tick
		end
	end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------

function TG_Direction(fpos,spos)
  local DIR=( fpos - spos):Normalized()
  DIR.z=0
  return DIR
end

------------------------------------------------------------------------------------------------------------------------------------------

function TG_Direction2(fpos,spos)
  local DIR=( fpos - spos):Normalized()
  return DIR
end