local rtime = 370 -- секунд на руду
local font, act,start,resources,pool_mrkr, pool_marker, pool_chkpnt = renderCreateFont('Arial', 10, 5), false, nil, {}, {}, {}, {}

function main()
    repeat wait(0) until isSampAvailable()
	sampAddChatMessage("{FFC300}[Mine Time Render by GoxaShow]{FFFFFF} Запущен! Создатель - {FF0000}youtube.com/goxashow{FFFFFF} | Тема скрипта: blast.hk/threads/95291",-1)
    sampRegisterChatCommand('mine', function() 
        act = not act
		for i = 1, 3000 do
            resources[i] = {}
            for a = 1, 4 do
                resources[i][a] = 0
            end
        end
		start = act and os.time() or nil
		sampAddChatMessage(act and "{FFC300}[Mine Time Render by GoxaShow]{FFFFFF} Включен!" or '{FFC300}[Mine Time Render by GoxaShow]{FFFFFF} Выключен!',-1)
    end)
	while true do wait(0)
		if act then
			if not isCharInArea3d(PLAYER_PED, 393.10, 716.46, 15, 769.71, 1017.04, -55, false) then
				sampAddChatMessage("{FFC300}[Mine Time Render by GoxaShow]{FFFFFF} Вы вышли с шахты, поэтому скрипт выключен!",-1)
				act = false
				for i = 1, 3000 do
					resources[i] = {}
					for a = 1, 4 do
						resources[i][a] = 0
					end
				end
			end
			if os.time() - start >= 1 then
				start = os.time()
				for i = 1, 3000 do
					if resources[i][4] > 0 then
						resources[i][4] = resources[i][4] - 1
						if resources[i][4] == 15 then
							metka(resources[i][1],resources[i][2],resources[i][3])
							local pX,pY,pZ = getCharCoordinates(1)
							local dist = math.floor(getDistanceBetweenCoords3d(pX,pY,pZ, resources[i][1],resources[i][2],resources[i][3]))
							sampAddChatMessage("{FFC300}[Mine Time Render by GoxaShow]{FFFFFF} Через ~15 секунд, в "..dist.." метрах от вас, появится руда!",-1)
						elseif resources[i][4] == 0 then
							for a = 1, 4 do
								resources[i][a] = 0
							end
						end
					end
				end
            end
			for i = 1, 3000 do
				if resources[i][4] > 0 then
					local obX, obY, obZ = resources[i][1],resources[i][2],resources[i][3]
					if isPointOnScreen(obX, obY, obZ, 0.0) then
						local wX, wY = convert3DCoordsToScreen(obX, obY, obZ)
						local timer = changetime(resources[i][4])
						renderFontDrawText(font, "Появится через "..timer.."!", wX, wY, -1)
					end
				end
			end
		end
	end
end

function onReceiveRpc(id, bs)
	if id == 58 and act then
		local tid = raknetBitStreamReadInt16(bs)
		if sampIs3dTextDefined(tid) then
			local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(tid)
			local pX,pY,pZ = getCharCoordinates(1)
			if text:find("Месторождение ресурсов") then
				if getDistanceBetweenCoords3d(pX,pY,pZ,posX, posY, posZ) < 90 then
					local oid2 = check(posX, posY, posZ)
					if oid2 == -1 then
						local tid = tid - 1000
						resources[tid][1] = posX
						resources[tid][2] = posY
						resources[tid][3] = posZ
						resources[tid][4] = rtime
					elseif oid2 > -1 then
						resources[oid2][1] = posX
						resources[oid2][2] = posY
						resources[oid2][3] = posZ
						resources[oid2][4] = rtime
					end
				end
			end
		end
		return true
	elseif id == 47 and act then
		local oid = raknetBitStreamReadInt16(bs)
		local object = sampGetObjectHandleBySampId(oid)
		if doesObjectExist(object) then
			if getObjectModel(object) == 3930 then
				local res, oX,oY,oZ = getObjectCoordinates(object)
				local pX,pY,pZ = getCharCoordinates(1)
				if getDistanceBetweenCoords3d(pX,pY,pZ,oX,oY,oZ) < 45 then
					local oid2 = check(oX,oY,oZ)
					if oid2 == -1 then
						resources[oid][1] = oX
						resources[oid][2] = oY
						resources[oid][3] = oZ+1
						resources[oid][4] = rtime
					elseif oid2 > -1 then
						resources[oid2][1] = oX
						resources[oid2][2] = oY
						resources[oid2][3] = oZ+1
						resources[oid2][4] = rtime
					end
				end
			end
		end
		return true
	end
end

function check(x,y,z)
	for i = 1, 3000 do
		if getDistanceBetweenCoords3d(resources[i][1], resources[i][2], resources[i][3], x,y,z) < 2 and resources[i][4] > 0 then
			return i
		end
	end
	return -1
end

function changetime(time)
	local min = math.floor(time/60)
	local sec = time % 60
	if min ~= 0 then
		return "\n  {FF0000}"..min.."{FFFFFF} мин , {FF0000}"..sec.."{FFFFFF} сек"
	else
		return "{FF0000}"..sec.."{FFFFFF} сек"
	end
end

function metka(x,y,z)
	local n = #pool_mrkr + 1
	local g = #pool_chkpnt + 1
	local h = #pool_marker + 1
	pool_mrkr[n] = createUser3dMarker(x, y, z + 2, 4)
	pool_chkpnt[g] = addBlipForCoord(x, y, z)
	changeBlipColour(pool_chkpnt[g], 0xFF00003FF)
	pool_marker[h] = createCheckpoint(1, x, y, z, 1, 1, 1, 1.5)
	lua_thread.create(function()
	wait(15000)
	deleteCheckpoint(pool_marker[h])
    removeBlip(pool_chkpnt[g])
	removeUser3dMarker(pool_mrkr[n])
	pool_chkpnt[g] = nil
	pool_mrkr[n] = nil
	pool_marker[h] = nil
	end)
end