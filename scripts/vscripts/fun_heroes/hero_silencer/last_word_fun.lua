﻿function last_word_fun(keys)

     local caster = keys.caster
     local target = keys.unit
     local ability = keys.ability
     local time = ability:GetSpecialValueFor("debuff_duration")
     local cooldown = ability:GetSpecialValueFor("cooldown")
     local event_ability = keys.event_ability
     local modifier_debuff_1 = "modifier_silencer_last_word_disarm"
     local modifier_debuff_2 = "modifier_last_word_fun_debuff"
     local modifier_cooldown = "modifier_last_word_fun_cooldown"

     if caster:PassivesDisabled() or target:IsMagicImmune() or target:HasModifier(modifier_cooldown) then return end  --破坏状态下、技能免疫目标、内置冷却期间不触发
     if event_ability:IsItem() or event_ability:IsChanneling() or not event_ability:ProcsMagicStick() then return end  --物品类技能、持续施法类技能还未结束时、技能不充能魔棒不触发

     target:EmitSound("Hero_Silencer.Curse")
     target:EmitSound("Hero_Silencer.Curse.Impact")

     ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_1, { duration = time})        --沉默和锁闭
     ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_2, { duration = time})        --减速和缴械
     ability:ApplyDataDrivenModifier(caster, target, modifier_cooldown, { duration = cooldown})    --内置冷却
       
end
