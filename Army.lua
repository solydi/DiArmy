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
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������!')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
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


local main_window_state = imgui.ImBool(false) -- ��������� ����
local text_buffer = imgui.ImBuffer(256) -- �����-�����, 256(����) �����������
]]

function main()
	-- ������������� ���������, ��� ������ ��������
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	sampAddChatMessage('{F48B8C}[INFO] {ffffff}������ {B8860B}"Army" {ffffff}����� � ������! �����: {ff7e14}solodi {ffffff}| ������: ' .. thisScript().version,-1)

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
        imgui.Text(u8"������ ������������ ��� ���������� ������ � �����.", 2);

    imgui.Separator()


    imgui.End()
end
]]


function se.onShowDialog(id, style, title, button1, button2, text)
    local dialogSkip = {
		[15254] = 1, -- ������� ���������
        [254] = 1, -- ����������� � ����� �� ������
        [7551] = 1,   -- �����/����� ����� ��� ��������������� �������������
    }

    -- �������� �� id
    if dialogSkip[id] ~= nil then
        sampSendDialogResponse(id, dialogSkip[id])
        return false
    end

    -- ������� � �����
    local textSkip = {
        ["����� ��������� �������� ��� ���������� ������ �� ������ ������ � ����� �� ���� ����"] = "{73B461}[����������] {ffffff}������������� �� �������� ��� �������� ��������.",
        ["��� ��������� �������� ������������� �� �������� ��������� � ���������� ��� �������."] = "{73B461}[����������] {ffffff}�� ����� �������� ���������� ����� �������� ��������.",
        ["��� �������� ���������� ������������� �� �������� ��������� � �������"] = "{73B461}[����������] {ffffff}������������� �� �������� ��� �������� ������������.",
        ["� ��������� ������������ ������������!"] = "{73B461}[����������] {ffffff}� ��������� ��� ������������. ��������� �� �� ������.",
        ["�� ������� ��������� ��������."] = "{73B461}[����������] {ffffff}�� ��������� �������� �������������.",
        ["�� ������� ��������� ���� � ������������� ��� ������������ ������."] = "{73B461}[����������] {ffffff}�� ������� ��������� ���� � �������������.",
        ["� ��������� �� ���������� �����!"] = "{73B461}[����������] {ffffff}��� �������� ��� {FF0000}�������� {ffffff}�������������.",
        ["� ��������� ��� ������������!"] = "{73B461}[����������] {ffffff}� ��������� ��� ������������. ��������� �� �� ������.",
        ["����� ������� ������ � ������� �������� ��� ��������� ���������� �� �����!"] = "{73B461}[����������] {ffffff}�� ������� ��������������� ����� {fdbf78}'���������� 10 ������ � �������� �� �����'{ffffff}.",
        ["������ ���� ������, ���� ������ ���� �� ������ ��������� ��������� ������!"] = "{73B461}[����������] {ffffff}�� ������� ��������������� ����� {fdbf78}'����� �������'{ffffff}.",
        ["�� ��������� � �����! ���� ������ ��������������! ���� ������ � ��������� � ������"] = "{73B461}[����������] {ffffff}�� ������� ��������������� ����� {fdbf78}'����� �������'{ffffff}.",
        ["�� �� � ����� �� ������ ���. ��������� ������ ����� ����������� ���"] = "{73B461}[����������] {ffffff}�� ������� ��������������� ����� {fdbf78}'������� �����'{ffffff}. ��� ���������� �������� 12 ����� ��� ��������� ��������."
    }

    -- �������� �� ������
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
    -- ��������� ��������� � ������ � ���������
    local messages = {
        ["�� ����� ���� � ���������. ������� ALT ����� ���������, ����� ��������� ���� � ����."] = "{73B461}[����������] {ffffff}�� ����� ���� � ���������.",
        ["�� �������� ���� � ��������� � ��������!"] = "{73B461}[����������] {ffffff}�� �������� ���� � ��������� � ��������.",
        ["�� ����� ���� � ��������� � ���������!"] = "{73B461}[����������] {ffffff}�� ����� ���� � ��������� �� ���������.",
        -- �������������� ��������� ������ ��������� 
        ["��� ���� ����� ������ �������� ������������ �����"] = "{73B461}[����������] {ffffff}����� ������ �������� ������������ ������� {FFA07A}[/carm] {ffffff}��� ����� {FFA07A}2{ffffff}.",
        ["� ����� �������� ������������ ��������!"] = "{73B461}[����������] {ffffff}� ����� �������� ������������ ��������."
    }

    for msg, chatMsg in pairs(messages) do
        if text:find(msg) then
            sampSendDialogResponse(id, 1, 0, false)
            sampAddChatMessage(chatMsg, -1)
            return false
        end
    end

    if string.find(text, ".+_.+%[.+] �������� �� �������� 5%.000 ������������ �� ����� ������ ���") then
        return { 0xF48B8CFF, text }
    end

end