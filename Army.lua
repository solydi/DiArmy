script_name("{ff7e14}Army")
script_author("{ff7e14}solodi")
script_version("0.0.1")

local encoding = require 'encoding'

encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется!')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/solydi/DiArmy/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/solydi/DiArmy"
        end
    end
end

local se = require("samp.events")
--[[local imgui = require 'imgui'
local vkeys = require 'vkeys'


local main_window_state = imgui.ImBool(false) -- состояние окна
local text_buffer = imgui.ImBuffer(256) -- текст-буфер, 256(байт) размерность
]]

function main()
	-- информативное сообщение, что скрипт работает
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	sampAddChatMessage('{F48B8C}[INFO] {ffffff}Скрипт {B8860B}"Army" {ffffff}готов к работе! Автор: {ff7e14}solodi {ffffff}| Версия: ' .. thisScript().version,-1)

    while not isSampAvailable() do
        wait(100)
    end

	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    wait(-1)
    --[[sampRegisterChatCommand("army", cmd_army)

    imgui.Process = false

    while true do
        wait(0)   
        if main_window_state.v == false then
            imgui.Process = false
        end
    end]]
end

--[[
function cmd_army(arg)
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()

    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)

    imgui.Begin("Army Helper", main_window_state, imgui.WindowFlags.NoCollapse+imgui.WindowFlags.NoResize+imgui.WindowFlags.NoMove)
        imgui.Text(u8"Скрипт предназначен для упрощенной работы в армии.", 2);

    imgui.Separator()


    imgui.End()
end
]]


function se.onShowDialog(id, style, title, button1, button2, text)
    local dialogSkip = {
		[15254] = 1, -- разгруз грузовика
        [254] = 1, -- переодеться в форму на заводе
        [7551] = 1,   -- одеть/снять форму без дополнительного подтверждения
    }

    -- проверка по id
    if dialogSkip[id] ~= nil then
        sampSendDialogResponse(id, dialogSkip[id])
        return false
    end

    -- диалоги в текст
    local textSkip = {
        ["Чтобы загрузить грузовик Вам необходимо встать на пикапе склада и взять от туда ящик"] = "{73B461}[Информация] {ffffff}Отправляйтесь на чекпоинт для загрузки матовоза.",
        ["Для разгрузки патронов отправляйтесь по красному чекпоинту и разгрузите там матовоз."] = "{73B461}[Информация] {ffffff}На карте отмечено чекпоинтом точку разгруза матовоза.",
        ["Для загрузки материалов отправляйтесь по красному чекпоинту и введите"] = "{73B461}[Информация] {ffffff}Отправляйтесь на чекпоинт для загрузки ингредиентов.",
        ["В вертолете недостаточно ингредиентов!"] = "{73B461}[Информация] {ffffff}В вертолете нет ингредиентов. Загрузите их на заводе.",
        ["Вы успешно загрузили вертолет."] = "{73B461}[Информация] {ffffff}Вы загрузили вертолет ингредиентами.",
        ["Вы успешно доставили груз с ингредиентами для изготовления оружия."] = "{73B461}[Информация] {ffffff}Вы успешно доставили груз с ингредиентами.",
        ["В вертолете не достаточно места!"] = "{73B461}[Информация] {ffffff}Ваш вертолет уже {FF0000}загружен {ffffff}ингредиентами.",
        ["В вертолете нет ингредиентов!"] = "{73B461}[Информация] {ffffff}В вертолете нет ингредиентов. Загрузите их на заводе.",
        ["Самое любимая задача у силовых структур это разгрузка материалов на склад!"] = "{73B461}[Информация] {ffffff}Вы приняли организационный квест {fdbf78}'Разгрузить 10 ящиков с матовоза на склад'{ffffff}.",
        ["Служба дело святое, твоя задача хотя бы просто создавать видимость работы!"] = "{73B461}[Информация] {ffffff}Вы приняли организационный квест {fdbf78}'Время служить'{ffffff}.",
        ["Ты вступаешь в наряд! Твоя задача патрулирование! Бери оружие и приступай к задаче"] = "{73B461}[Информация] {ffffff}Вы приняли организационный квест {fdbf78}'Пеший патруль'{ffffff}.",
        ["Ты же в армии не просто так. Наверняка хочешь стать полицейским или"] = "{73B461}[Информация] {ffffff}Вы приняли организационный квест {fdbf78}'Военный билет'{ffffff}. Вам необходимо отыграть 12 часов для получения военника."
    }

    -- проверка по тексту
    for key, message in pairs(textSkip) do
        if text:find(key) then
            sampSendDialogResponse(id, 1, 0, false)
            if message then
                sampAddChatMessage(message, -1)
            end
            return false
        end
    end

    if id == 15253 then
        sampSendDialogResponse(15253, 2, 1)
        return false
    end
end

function se.onServerMessage(color, text)
    -- обработка сообщений о ящиках с патронами
    local messages = {
        ["Вы взяли ящик с патронами. Нажмите ALT сзади грузовика, чтобы погрузить ящик в него."] = "{73B461}[Информация] {ffffff}Вы взяли ящик с патронами.",
        ["Вы положили ящик с патронами в грузовик!"] = "{73B461}[Информация] {ffffff}Вы положили ящик с патронами в грузовик.",
        ["Вы взяли ящик с патронами с грузовика!"] = "{73B461}[Информация] {ffffff}Вы взяли ящик с патронами из грузовика.",
        -- информационное сообщение вместо подсказки 
        ["Для того чтобы начать развозку оборудования введи"] = "{73B461}[Информация] {ffffff}Чтобы начать развозку оборудования введите {FFA07A}[/carm] {ffffff}или нажми {FFA07A}2{ffffff}.",
        ["В вашем матовозе недостаточно патронов!"] = "{73B461}[Информация] {ffffff}В вашем матовозе недостаточно патронов."
    }

    for msg, chatMsg in pairs(messages) do
        if text:find(msg) then
            sampSendDialogResponse(id, 1, 0, false)
            sampAddChatMessage(chatMsg, -1)
            return false
        end
    end

    if string.find(text, ".+_.+%[.+] доставил на вертолёте 5%.000 ингредиентов на склад завода ТСР") then
        return { 0xF48B8CFF, text }
    end

end