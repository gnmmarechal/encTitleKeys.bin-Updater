local white = Color.new(255,255,255)
local yellow = Color.new(255,205,66)
local red = Color.new(255,0,0)
local green = Color.new(55,255,0)
local curPos = 20
local motd = ""
local size = 0
local usersize = 0

local pad = Controls.read()
local oldpad = pad

function sleep(n)
  local timer = Timer.new()
  local t0 = Timer.getTime(timer)
  while Timer.getTime(timer) - t0 <= n do end
end

function update()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.waitVblankStart()
    Screen.flip()
    if Network.isWifiEnabled() then
        Screen.debugPrint(5,5, "Downloading...", green, TOP_SCREEN)
        if System.doesFileExist("/f4g5h6.zip") then
        System.deleteFile("/f4g5h6.zip")
        end
        System.createDirectory("/freeShop")
        Network.downloadFile("http://3ds.titlekeys.gq/downloadenc", "/encTitleKeysTemp.bin")
        if System.doesFileExist("/encTitleKeysTemp.bin") then
        	if System.doesFileExist("/3ds/data/freeShop/keys/encTitleKeys.bin") then
        		System.deleteFile("/3ds/data/freeShop/keys/encTitleKeys.bin")
        end
        Screen.debugPrint(5,35, "Renaming...", green, TOP_SCREEN)
        System.renameFile("/encTitleKeysTemp.bin", "/3ds/data/freeShop/keys/encTitleKeys.bin")
        Screen.debugPrint(5,65, "Done!", green, TOP_SCREEN)



        while true do
          Screen.waitVblankStart()
          Screen.flip()
          System.launchCIA(0x0f12ee00,SDMC)
        end

    else
        Screen.debugPrint(5,5, "Wi-Fi is disabled. Restart and try again.", red, TOP_SCREEN)
        Screen.debugPrint(5,20, "Press A to go back to Home Menu", red, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_A) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            end
        end
    end
end


function init()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    if Network.isWifiEnabled() then
        motd = Network.requestString("http://matmaf.github.io/encTitleKeys.bin-Updater/motd")
        size = tonumber(Network.requestString("http://matmaf.github.io/encTitleKeys.bin-Updater/size"))
        if System.doesFileExist("/freeShop/encTitleKeys.bin") then
            local fileStream = io.open("/freeShop/encTitleKeys.bin", FREAD)
            usersize = tonumber(io.size(fileStream))
            io.close(fileStream)
        end
    else
        Screen.debugPrint(5,5, "Wi-Fi is disabled. Restart and try again.", red, TOP_SCREEN)
        Screen.debugPrint(5,20, "Press A to go back to Home Menu", red, TOP_SCREEN)
        Screen.waitVblankStart()
        Screen.flip()
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_A) then
            System.exit()
            end
        end
    end
end

function main()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.debugPrint(5,5, "encTitleKeysUpdater-Launcher for freeShop", yellow, TOP_SCREEN)
    Screen.debugPrint(30,200, "Based on v1.2.1", white, TOP_SCREEN)
    Screen.debugPrint(30,215, "Forked from MatMaf", white, TOP_SCREEN)
    if usersize == size then
        Screen.debugPrint(5,20, "encTitleKeys.bin is up to date.", green, BOTTOM_SCREEN)
    else
        Screen.debugPrint(5,20, "encTitleKeys.bin is not up to date.", red, BOTTOM_SCREEN)
    end
    Screen.debugPrint(5,5, motd, white, BOTTOM_SCREEN)
    Screen.flip()

    while true do
      update()
    end
end

init()
main()
