local VORPcore = exports.vorp_core:GetCore()-

local VORPMenu = {}

TriggerEvent("vorp_menu:getData", function(cb)
    VORPMenu = cb
end)



RegisterNetEvent('jobbook:openbook')
AddEventHandler('jobbook:openbook', function(city, region)
    OpenMainMenu()
end)
function OpenMainMenu()
    VORPMenu.CloseAll()
    local menuElements = {
        { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" },
    }
    local addMenuElement
    addMenuElement = { label = "Switch Job", value = "switch", desc = "Change Jobs" }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = { label = "Save Job", value = "save", desc = "Save Current Job" }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = { label = "Quit Job", value = "quit", desc = "Quit a Job" }
    table.insert(menuElements, 1, addMenuElement)
    -- Open the menu using VORPMenu
    VORPMenu.Open(
        "default",
        GetCurrentResourceName(),
        "mainmenu",
        {
            title = "Jobbook Menu",
            subtext = "Career Management",
            align = "top-center",
            elements = menuElements,
            itemHeight = "4vh",
        },
        function(data, menu)
            if data.current.value == "switch" then
                OpenSwitchMenu()
            elseif data.current.value == "save" then
                OpenSaveMenu()
            elseif data.current.value == "quit" then
                OpenQuitMenu()
            elseif data.current.value == "exit_menu" then
                print("close")
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSwitchMenu()
    VORPMenu.CloseAll()
    local menuElements = {}
    local addMenuElement
    addMenuElement = { label = "Main Menu", value = "back", desc = "Back to Main Menu" }
    table.insert(menuElements, addMenuElement)
    addMenuElement = { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" }
    table.insert(menuElements, addMenuElement)
    --Here need to get all jobs the person has
    TriggerEvent("vorp:ExecuteServerCallBack", "jobbook:getjobs", function(cb)
        local result = cb
        if #cb == 0 then
            print("No jobs")
            TriggerEvent("vorp:TipBottom", "You don't have any jobs", 4000)
        end

        for k, v in pairs(cb) do
            label = cb[k].jobdata
            value = cb[k].jobdata
            addMenuElement = { label = label, value = value, desc = "Select this job" }
            table.insert(menuElements, addMenuElement)
        end

        addMenuElement = { label = "Main Menu", value = "back", desc = "Back to Main Menu" }
        table.insert(menuElements, addMenuElement)
        addMenuElement = { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" }
        table.insert(menuElements, addMenuElement)


        -- Open the menu using VORPMenu
        VORPMenu.Open(
            "default",
            GetCurrentResourceName(),
            "resultsmenu",
            {
                title = "View Lottery Results",
                subtext = "",
                align = "top-center",
                elements = menuElements,
                itemHeight = "4vh",
            },
            function(data, menu)
                if data.current.value == "back" then
                    OpenStartMenu()
                elseif data.current.value == "exit_menu" then
                    print("close")
                    menu.close()
                else
                    print("here")
                end
            end,
            function(data, menu)
                menu.close()
            end)
    end)
   
end

function OpenSaveMenu()
    --- Trigger a client callback Synchronously
    ClientRPC.Callback.TriggerASync(saveJob, function(result)
    print(result)
   end,)


end

RegisterCommand("openjobbook", function()
   
end)
