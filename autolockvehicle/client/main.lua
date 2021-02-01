local isShowing = false
local distanceToVehicle = 3 -- Arac'a ne kadar uzak olunacağında aracı kitlesin ve kilidini açsın
local delayTime = 500 -- Kaç saniyede bir kontrol etsin

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(delayTime)
        local ped = GetPlayerPed(PlayerId())
        local lastVeh = GetVehiclePedIsIn(ped, true)
        local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(lastVeh), 1)
        local vehLockStatus = GetVehicleDoorLockStatus(lastVeh)
        if GetLastPedInVehicleSeat(lastVeh, -1) == ped and GetVehicleDoorAngleRatio(lastVeh, 0) <= 0 and GetVehicleDoorAngleRatio(lastVeh, 1) <= 0 then
            if distanceToVeh <= distanceToVehicle then
                isShowing = false
                if vehLockStatus == 2 and isShowing == false then
                    SetVehicleDoorsLocked(lastVeh, 0)
                    SetVehicleDoorsLockedForAllPlayers(lastVeh, false)
                    showInfo("~g~"..GetDisplayNameFromVehicleModel(GetEntityModel(lastVeh)).."~s~ aracın kilidi açıldı.")
                    isShowing = true
                end
            else
                if vehLockStatus == 1 or vehLockStatus == 0 and isShowing == false then
                    SetVehicleDoorsLocked(lastVeh, 2)
                    SetVehicleDoorsLockedForAllPlayers(lastVeh, true)
                    showInfo("~g~"..GetDisplayNameFromVehicleModel(GetEntityModel(lastVeh)).."~s~ aracın kilitlendi.")
                    isShowing = true
                end
            end
        end
    end
end)

function showInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end