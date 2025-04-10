--[[Author: Pizzalol
	Date: 09.02.2015.
	Triggers when the unit attacks
	Checks if the attack target is the same as the caster
	If true then trigger the counter helix if its not on cooldown]]
function CounterHelix( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local helix_modifier = keys.helix_modifier
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	

	if caster:PassivesDisabled() then return end      --新增破被动效果
	

	if ability:IsCooldownReady() then
	-- If the caster has the helix modifier then do not trigger the counter helix
	-- as its considered to be on cooldown
	
			if target == caster and not caster:HasModifier(helix_modifier) then
				ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
				
				ability:StartCooldown(cooldown)
			end
	end

end


function zhansha( every )
	local caster = every.caster
	local target = every.target
	local tether = caster:FindAbilityByName("axe_culling_blade")
--tether:SetLevel(2)
--tether:EndCooldown()

	--if caster:PassivesDisabled() then return end      --新增破被动效果，没有该行代码斩杀效果也会被破坏禁用，因为前置的修饰器会被破坏禁用

    if caster:HasScepter() and target:IsRealHero() and target:GetHealth() < 500 then
        caster:SetCursorCastTarget(target)
        tether:OnSpellStart()
	end
	-- body
end
