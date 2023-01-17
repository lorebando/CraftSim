addonName, CraftSim = ...

CraftSim.NEWS = {}

function CraftSim.NEWS:GET_NEWS()
    -- minimize names to make manual formatting easier :p
    local b = CraftSim.CONST.COLORS.DARK_BLUE
    local bb = CraftSim.CONST.COLORS.BRIGHT_BLUE
    local g = CraftSim.CONST.COLORS.GREEN
    local r = CraftSim.CONST.COLORS.RED
    local l = CraftSim.CONST.COLORS.LEGENDARY
    local c = function(text, color) 
        return CraftSim.UTIL:ColorizeText(text, color)
    end
    local p = "\n" .. CraftSim.UTIL:GetQualityIconAsText(1, 15, 15) .. " "
    local s = "\n" .. CraftSim.UTIL:GetQualityIconAsText(2, 15, 15) .. " "
    local P = "\n" .. CraftSim.UTIL:GetQualityIconAsText(3, 15, 15) .. " "
    local a = "\n     "
    local function newP(v) return c("\n\n\n                                   --- Version " .. v .. " ---\n\n", l) end
    -- local tunaData = CraftSim.DATAEXPORT:GetItemFromCacheByItemID(199345, true)
    -- local frostedTunaData = CraftSim.DATAEXPORT:GetItemFromCacheByItemID(200074)
    return 
        c("                   Hello and thank you for using CraftSim!\n", bb) .. 
        "             ( Show this window any time with " .. c("/craftsim news", g) .. " )" ..
        newP("2.1") ..
        p .. "Updated the multicraft extra items formula to " ..
        a .. c("(1+2.5y*bonus) / 2", bb) .. 
        a .. "instead of " ..
        a .. c("((1+2.5y) / 2)*bonus", bb) .. 
        a .. "which leads to slightly less but more" .. 
        a .. "accurate value from multicraft" ..
        p .. "Fixed an error during prospecting and other salvage recipes" .. 
        p .. "Fixed a bug causing the Simulate Top Gear button" ..
        a .. "to not update" .. 
        p .. "Fixed racial skill boni being applied two times" .. 
        a .. "when using experimental spec data" .. 
        newP("2.0") ..
        P .. "Implemented most modules for " .. c("Work Orders", g) ..
        a .. "Simulation Mode for work orders will follow" .. 
        a .. "in a future update." .. 
        a .. "Behaviour of the Work Order Modules during recrafting" .. 
        a .. "is not tested yet" .. 
        P .. "Introducing the " .. c("CraftSim Control Panel", g) ..
        a .. "Serving as the main module of CraftSim from now on" .. 
        a .. "it gives easy access to all different modules" ..
        s .. c("Removed", r) .. " the price override feature temporary" .. 
        a .. "This will be reimplemented as a seperate module" .. 
        a .. "in a future update" .. 
        newP("1.8.3") ..
        s .. "Fixed " .. c("Material Suggestion", bb) .. " sometimes suggesting" .. 
        a .. "too low quality mats." ..
        a .. "Thanks to " .. c("https://github.com/AkiKonani", bb) .. 
        a .. "for suggesting a small but effective solution!" .. 
        newP("1.8.2") ..
        p .. "Fixed " .. c("Inspiration Bonus Skill", bb) .. " sometimes being too high" .. 
        a .. "due to rounding differences" .. 
        newP("1.8.1") ..
        P .. c("Jewelcrafting", bb) .. " experimental specialization data added" .. 
        a .. "This makes knowledge point distribution simulation possible!" .. 
        a .. "If you want to try it out, activate " .. 
        a .. c("'Jewelcrafting Experimental Data'", bb) .. 
        a .. "in the CraftSim Options: " .. c("/craftsim", g) ..
        newP("1.8") ..
        P .. c("Knowledge Distribution Simulation", g) .. " added for " .. 
        a .. c("Blacksmithing", bb) .. " and " .. c("Alchemy", bb) .. " (Experimental Data only)" .. 
        s .. c("Top Gear Simulation", g) .. " is now on demand " ..
        a .. "due to performance reasons" ..
        p .. "Added profiling checkpoints to view in " .. c("Debug Mode", bb) .. 
        p .. "Cache utilization added for some data to increase performance" .. 
        newP("1.7.8") .. 
        P .. "koKR (Korean) Localization added" .. 
        a .. "(Thank you " .. c("github.com/comiluv", bb) .. ")" ..
        P .. "zhTW (Taiwan) Localization added" .. 
        a .. "(Thank you " .. c("github.com/Tmv3v", bb) .. ")" ..
        newP("1.7.7") ..
        P .. "New News Format!" ..
        s .. "New " .. c("Export Data", g) .. " command: " .. c("/craftsim export", g) .. 
        a .."Lets you export the information about a recipe in CSV format!" .. 
        a .. c("More Info will follow", bb) ..
        p .. "Fixed " .. c("Stable Fluid Draconium", bb) .. " granting" ..
        a .. "15% Inspiration on all ranks" ..
        p .. "Fixed an error when other addons are " ..
        a .. "hiding the ProfessionsFrame" ..
        p .. c("Max Reagent Skill Increase", bb) .. " is now always calculated based " ..
        a .. "on API results." .. 
        a .. "This is because some non recraft recipes are not " ..
        a .. "using the standard 25% Recipe Difficulty"
end