

function all_PerformAttack (keys)

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local spawn_location = caster:GetOrigin()
	


			Timers:CreateTimer(0.33, function()
						--异步攻击，否则一起木大木大会BOOM
						
						
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin() )
					ParticleManager:SetParticleControl(pfx, 1, keys.target:GetAbsOrigin() )
					ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", keys.target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(pfx)


				caster:PerformAttack(target, false, false, false, false, true, false, true)

					
			--[[(target: CDOTA_BaseNPC, 
			useCastAttackOrb: bool, 是否触发法球效果
			processProcs: bool, 目前测试结果是这个为false, bUseProjectile为true的话
								才会有投射物出现，其它方面的影响忘了~
								
			skipCooldown: bool, 如果为true忽略攻击间隔
			ignoreInvis: bool, 是否忽略隐身单位
			useProjectile: bool,是否使用投射物
			
			fakeAttack: bool,如果为true就不会触发OnAttackLanded之类的事件，
								一般为true，如果设置为false并且放在OnAttackLanded之类的事件中
								容易发生死循环
			neverMiss: bool)是否克敌先机
					
				]]	
					--target damage
					return 0.33
					
					end
				)





	end


























TIMERS_THINK = 0.01

if Timers == nil then
  print ( '[Timers] creating Timers' )
  Timers = {}
  Timers.__index = Timers
end

function Timers:new( o )
  o = o or {}
  setmetatable( o, Timers )
  return o
end

function Timers:start()
  Timers = self
  self.timers = {}
  
  local ent = Entities:CreateByClassname("info_target") -- Entities:FindByClassname(nil, 'CWorld')
  ent:SetThink("Think", self, "timers", TIMERS_THINK)
end

function Timers:Think()
  if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return
  end

  -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
  local now = GameRules:GetGameTime()

  -- Process timers
  for k,v in pairs(Timers.timers) do
    local bUseGameTime = true
    if v.useGameTime ~= nil and v.useGameTime == false then
      bUseGameTime = false
    end
    local bOldStyle = false
    if v.useOldStyle ~= nil and v.useOldStyle == true then
      bOldStyle = true
    end

    local now = GameRules:GetGameTime()
    if not bUseGameTime then
      now = Time()
    end

    if v.endTime == nil then
      v.endTime = now
    end
    -- Check if the timer has finished
    if now >= v.endTime then
      -- Remove from timers list
      Timers.timers[k] = nil
      
      -- Run the callback
      local status, nextCall = pcall(v.callback, GameRules:GetGameModeEntity(), v)

      -- Make sure it worked
      if status then
        -- Check if it needs to loop
        if nextCall then
          -- Change its end time

          if bOldStyle then
            v.endTime = v.endTime + nextCall - now
          else
            v.endTime = v.endTime + nextCall
          end

          Timers.timers[k] = v
        end

        -- Update timer data
        --self:UpdateTimerData()
      else
        -- Nope, handle the error
        Timers:HandleEventError('Timer', k, nextCall)
      end
    end
  end

  return TIMERS_THINK
end

function Timers:HandleEventError(name, event, err)
  print(err)

  -- Ensure we have data
  name = tostring(name or 'unknown')
  event = tostring(event or 'unknown')
  err = tostring(err or 'unknown')

  -- Tell everyone there was an error
  --Say(nil, name .. ' threw an error on event '..event, false)
  --Say(nil, err, false)

  -- Prevent loop arounds
  if not self.errorHandled then
    -- Store that we handled an error
    self.errorHandled = true
  end
end

function Timers:CreateTimer(name, args)
  if type(name) == "function" then
    args = {callback = name}
    name = DoUniqueString("timer")
  elseif type(name) == "table" then
    args = name
    name = DoUniqueString("timer")
  elseif type(name) == "number" then
    args = {endTime = name, callback = args}
    name = DoUniqueString("timer")
  end
  if not args.callback then
    print("Invalid timer created: "..name)
    return
  end


  local now = GameRules:GetGameTime()
  if args.useGameTime ~= nil and args.useGameTime == false then
    now = Time()
  end

  if args.endTime == nil then
    args.endTime = now
  elseif args.useOldStyle == nil or args.useOldStyle == false then
    args.endTime = now + args.endTime
  end

  Timers.timers[name] = args
end

function Timers:RemoveTimer(name)
  Timers.timers[name] = nil
end

function Timers:RemoveTimers(killAll)
  local timers = {}

  if not killAll then
    for k,v in pairs(Timers.timers) do
      if v.persist then
        timers[k] = v
      end
    end
  end

  Timers.timers = timers
end

Timers:start()