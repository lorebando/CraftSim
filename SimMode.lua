addonName, CraftSim = ...

CraftSim.SIMULATION_MODE = {}

CraftSim.SIMULATION_MODE.isActive = false
CraftSim.SIMULATION_MODE.reagentOverwriteFrame = nil
CraftSim.SIMULATION_MODE.craftingDetailsFrame = nil
CraftSim.SIMULATION_MODE.recipeData = nil
CraftSim.SIMULATION_MODE.baseSkill = nil
CraftSim.SIMULATION_MODE.reagentSkillIncrease = nil

CraftSim.SIMULATION_MODE.baseInspiration = nil
CraftSim.SIMULATION_MODE.baseMulticraft = nil
CraftSim.SIMULATION_MODE.baseResourcefulness = nil

function CraftSim.SIMULATION_MODE:Init()

    CraftSim.FRAME:InitSimModeFrames()
end

function CraftSim.SIMULATION_MODE:OnInputAllocationChanged(userInput)
    if not userInput or not CraftSim.SIMULATION_MODE.recipeData then
        return
    end
    local inputBox = self
    local reagentData = CraftSim.SIMULATION_MODE.recipeData.reagents[inputBox.reagentIndex]

    local inputNumber = CraftSim.UTIL:ValidateNumberInput(inputBox)
    inputBox.currentAllocation = inputNumber

    local totalAllocations = CraftSim.UTIL:ValidateNumberInput(inputBox:GetParent().inputq1)
    local totalAllocations = totalAllocations + CraftSim.UTIL:ValidateNumberInput(inputBox:GetParent().inputq2)
    local totalAllocations = totalAllocations + CraftSim.UTIL:ValidateNumberInput(inputBox:GetParent().inputq3)

    -- if the total sum would be higher than the required quantity, force the smallest number to get the highest quantity
    if totalAllocations > reagentData.requiredQuantity then
        local otherAllocations = totalAllocations - inputNumber
        inputNumber = reagentData.requiredQuantity - otherAllocations
        inputBox:SetText(inputNumber)
    end
    --reagentData.itemsInfo[inputBox.qualityID].allocations = tonumber(inputNumber)

    CraftSim.SIMULATION_MODE:UpdateSimulationMode()
    CraftSim.MAIN:TriggerModulesByRecipeType()
end

function CraftSim.SIMULATION_MODE:OnStatModifierChanged(userInput)
    if not userInput then
        return
    end
    CraftSim.SIMULATION_MODE:UpdateSimulationMode()
    CraftSim.MAIN:TriggerModulesByRecipeType()
end

function CraftSim.SIMULATION_MODE:UpdateReagentAllocationsByInput()
    -- update item allocations based on inputfields
    for _, overwriteInput in pairs(CraftSim.SIMULATION_MODE.reagentOverwriteFrame.reagentOverwriteInputs) do
        if overwriteInput.isActive then
            local reagentIndex = overwriteInput.inputq1.reagentIndex
            local reagentData = CraftSim.SIMULATION_MODE.recipeData.reagents[reagentIndex]

            reagentData.itemsInfo[1].allocations = overwriteInput.inputq1:GetNumber()
            if reagentData.differentQualities then
                reagentData.itemsInfo[2].allocations = overwriteInput.inputq2:GetNumber()
                reagentData.itemsInfo[3].allocations = overwriteInput.inputq3:GetNumber()
            end
        end
    end
end

function CraftSim.SIMULATION_MODE:UpdateSimModeRecipeDataByInputs()
    -- update reagent skill increase by material allocation
    local reagentSkillIncrease = CraftSim.REAGENT_OPTIMIZATION:GetCurrentReagentAllocationSkillIncrease(CraftSim.SIMULATION_MODE.recipeData)
    CraftSim.SIMULATION_MODE.reagentSkillIncrease = reagentSkillIncrease

    -- update skill by input modifier and reagent skill increase
    local skillMod = CraftSim.UTIL:ValidateNumberInput(CraftSimSimModeSkillModInput, true)
    CraftSim.SIMULATION_MODE.recipeData.stats.skill = CraftSim.SIMULATION_MODE.baseSkill + reagentSkillIncrease + skillMod

    -- update difficulty based on input
    local recipeDifficultyMod = CraftSim.UTIL:ValidateNumberInput(CraftSimSimModeRecipeDifficultyModInput, true)
    CraftSim.SIMULATION_MODE.recipeData.recipeDifficulty = CraftSim.SIMULATION_MODE.baseRecipeDifficulty + recipeDifficultyMod

    -- update other stats
    if CraftSim.SIMULATION_MODE.recipeData.stats.inspiration then
        local inspirationMod = CraftSim.UTIL:ValidateNumberInput(CraftSimSimModeInspirationModInput, true)
        CraftSim.SIMULATION_MODE.recipeData.stats.inspiration.value = CraftSim.SIMULATION_MODE.baseInspiration.value + inspirationMod
        CraftSim.SIMULATION_MODE.recipeData.stats.inspiration.percent = CraftSim.UTIL:GetInspirationPercentByStat(CraftSim.SIMULATION_MODE.recipeData.stats.inspiration.value) * 100
        if CraftSim.SIMULATION_MODE.recipeData.stats.inspiration.percent > 100 then
            -- More than 100 is not possible and it does not make sense in the calculation and would inflate the worth
            CraftSim.SIMULATION_MODE.recipeData.stats.inspiration.percent = 100
        end
    end

    if CraftSim.SIMULATION_MODE.recipeData.stats.multicraft then
        local multicraftMod = CraftSim.UTIL:ValidateNumberInput(CraftSimSimModeMulticraftModInput, true)
        CraftSim.SIMULATION_MODE.recipeData.stats.multicraft.value = CraftSim.SIMULATION_MODE.baseMulticraft.value + multicraftMod
        CraftSim.SIMULATION_MODE.recipeData.stats.multicraft.percent = CraftSim.UTIL:GetMulticraftPercentByStat(CraftSim.SIMULATION_MODE.recipeData.stats.multicraft.value) * 100
        if CraftSim.SIMULATION_MODE.recipeData.stats.multicraft.percent > 100 then
            -- More than 100 is not possible and it does not make sense in the calculation and would inflate the worth
            CraftSim.SIMULATION_MODE.recipeData.stats.multicraft.percent = 100
        end
    end

    if CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness then
        local resourcefulnessMod = CraftSim.UTIL:ValidateNumberInput(CraftSimSimModeResourcefulnessModInput, true)
        CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness.value = CraftSim.SIMULATION_MODE.baseResourcefulness.value + resourcefulnessMod
        CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness.percent = CraftSim.UTIL:GetResourcefulnessPercentByStat(CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness.value) * 100
        if CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness.percent > 100 then
            -- More than 100 is not possible and it does not make sense in the calculation and would inflate the worth
            CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness.percent = 100
        end
    end

    -- adjust expected quality by skill if quality recipe
    if not CraftSim.SIMULATION_MODE.recipeData.result.isNoQuality then
        CraftSim.SIMULATION_MODE.recipeData.expectedQuality = CraftSim.STATS:GetExpectedQualityBySkill(CraftSim.SIMULATION_MODE.recipeData, CraftSim.SIMULATION_MODE.recipeData.stats.skill, CraftSimOptions.breakPointOffset)
    end
end

function CraftSim.SIMULATION_MODE:UpdateSimulationMode()
    CraftSim.SIMULATION_MODE:UpdateReagentAllocationsByInput()
    CraftSim.SIMULATION_MODE:UpdateSimModeRecipeDataByInputs()
    CraftSim.FRAME:UpdateSimModeStatDisplay()
end

function CraftSim.SIMULATION_MODE:InitializeSimulationMode(recipeData)
    CraftSim.SIMULATION_MODE.recipeData = CopyTable(recipeData)   
    CraftSim.SIMULATION_MODE.recipeData.isSimModeData = true

    -- initialize base values based on original recipeData
    local OldReagentSkillIncrease = CraftSim.REAGENT_OPTIMIZATION:GetCurrentReagentAllocationSkillIncrease(CraftSim.SIMULATION_MODE.recipeData)
    CraftSim.SIMULATION_MODE.baseSkill = CraftSim.SIMULATION_MODE.recipeData.stats.skill - OldReagentSkillIncrease
    CraftSim.SIMULATION_MODE.baseRecipeDifficulty = CraftSim.SIMULATION_MODE.recipeData.baseDifficulty
    
    if CraftSim.SIMULATION_MODE.recipeData.stats.inspiration then
        CraftSim.SIMULATION_MODE.baseInspiration = CopyTable(CraftSim.SIMULATION_MODE.recipeData.stats.inspiration)
    end
    
    if CraftSim.SIMULATION_MODE.recipeData.stats.multicraft then
        CraftSim.SIMULATION_MODE.baseMulticraft = CopyTable(CraftSim.SIMULATION_MODE.recipeData.stats.multicraft)
    end

    if CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness then
        CraftSim.SIMULATION_MODE.baseResourcefulness = CopyTable(CraftSim.SIMULATION_MODE.recipeData.stats.resourcefulness)
    end
    -- crafting speed... for later profit per time interval?

    -- update frame visiblity and initialize the input fields
    CraftSim.FRAME:ToggleSimModeFrames()
    CraftSim.FRAME:InitilizeSimModeReagentOverwrites()

    -- update simulation recipe data and frontend
    CraftSim.SIMULATION_MODE:UpdateSimulationMode()

    -- recalculate modules
    CraftSim.MAIN:TriggerModulesByRecipeType()
end