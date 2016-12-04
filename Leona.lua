
if GetObjectName(GetMyHero()) ~= "Leona" then return end

require("DamageLib")


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end

local SetDCP, SkinChanger = 0


local LeonaMenu = Menu("Leona", "Leona")

LeonaMenu:SubMenu("Combo", "Combo")
LeonaMenu.Combo:Boolean("Q", "Use Q in combo", true)
LeonaMenu.Combo:Boolean("W", "Use W in combo", true)
LeonaMenu.Combo:Boolean("E", "Use E in combo", true)
LeonaMenu.Combo:Boolean("R", "Use R in combo", true)

LeonaMenu:SubMenu("URFMode", "URFMode")
LeonaMenu.URFMode:Boolean("Level", "Auto level spells", false)
LeonaMenu.URFMode:Boolean("Ghost", "Auto Ghost", false)
LeonaMenu.URFMode:Boolean("Q", "Auto Q", false)
LeonaMenu.URFMode:Boolean("W", "Auto W", false)
LeonaMenu.URFMode:Boolean("E", "Auto E", false)

LeonaMenu:SubMenu("LaneClear", "LaneClear")
LeonaMenu.LaneClear:Boolean("Q", "Use Q", true)
LeonaMenu.LaneClear:Boolean("E", "Use E", true)

LeonaMenu:SubMenu("Harass", "Harass")
LeonaMenu.Harass:Boolean("Q", "Use Q", true)
LeonaMenu.Harass:Boolean("E", "Use E", true)

LeonaMenu:SubMenu("KillSteal", "KillSteal")
LeonaMenu.KillSteal:Boolean("E", "KS w E", true)

LeonaMenu:SubMenu("AutoIgnite", "AutoIgnite")
LeonaMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

LeonaMenu:SubMenu("Drawings", "Drawings")
LeonaMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
LeonaMenu.Drawings:Boolean("DE", "Draw E Range", true)
LeonaMenu.Drawings:Boolean("DR", "Draw R Range", true)

LeonaMenu:SubMenu("SkinChanger", "SkinChanger")
LeonaMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
LeonaMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()

	--AUTO LEVEL UP
	if LeonaMenu.URFMode.Level:Value() then 

			spellorder = {_Q, _E, _W, _Q, _E, _R, _Q, _W, _W, _Q, _R, _Q, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if IOW:Mode() == "Harass" then

            if LeonaMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
	                                CastSkillShot(_Q, target.pos) 
                       	
             end
             if LeonaMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, 850) then
				        CastSkillShot(_E, target)
             end
          end
	--COMBO
		     if IOW:Mode() == "Combo" then

             if LeonaMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 850) then
				          CastSpell(_W)
	     end
       
        if LeonaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 875) then
				          CastSkillShot(_E, target)
             end
			
	     if LeonaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 175) then
				         CastSpell(_Q) 
             end
            	                	     	    
       if LeonaMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1000) then
				          CastTargetSpell(target, _R)
             end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                
                if IsReady(_E) and ValidTarget(enemy, 850) and LeonaMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                    CastSkillShot(_E, target)
  
                end
      end

      if IOW:Mode() == "LaneClear" then

      	  for _,closeminion in pairs(minionManager.objects) do
	         if LeonaMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 800) then
	        	   CastSkillShot(_Q, closeminion)
	         end
          
           if LeonaMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 900) then
	        	   CastSkillShot(_E, closeminion)
	         end
      	 end
      end
        --URFMode
        if LeonaMenu.URFMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 800) then
		      CastSpell(_Q)
          end
        end 
        if LeonaMenu.URFMode.W:Value() and ValidTarget(target, 850) then        
          if Ready(_W) then
	  	      CastSpell(_W)
          end
        end
        if LeonaMenu.URFMode.E:Value() and ValidTarget(target, 850) then        
	        if Ready(_E) then
		      CastSkillShot(_E, target)
	        end
        end
                
	--AUTO IGNITE
	if LeonaMenu.URFMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if LeonaMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 800, 0, 150, GoS.Black)
	end

	if LeonaMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 875, 0, 150, GoS.Black)
	end

	if LeonaMenu.Drawings.DR:Value() then
		DrawCircle(GetOrigin(myHero), 1000, 0, 150, GoS.Black)
	end

end)

local function SkinChanger()
	if LeonaMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Leona</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')

