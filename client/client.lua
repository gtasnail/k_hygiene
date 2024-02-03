
if (GetResourceState('ox_lib') and GetResourceState('k_hygiene')) ~= 'started' then
    print('^1 Please make sure to install ox_lib and k_disease and make sure they are both started.')
    return
end

lib.registerMenu({
    id = 'hygiene',
    title = 'Current Hygiene',
    position = 'top-right',
    options = {}
})

function convertToPercentage(number, maxNumber)
    if number < 0 then
        number = 0
    elseif number > maxNumber then
        number = maxNumber
    end
    local percentage = ((number / maxNumber) * 100) -- Flipping the percentage
    return percentage
end

RegisterCommand('hygienes', function()
    local myHygienes = exports['k_hygiene-dev']:GetHygiene()
    hygienes = {
        {label = "Pee", icon = 'tint', description='Time until you piss.',  progress=100 - math.floor(convertToPercentage(myHygienes['Pee'].iterationsUntil, Config.HygieneStatus['Pee'].iterationsUntil)), colorScheme='gold', iconColor='gold', iconAnimation='beat', close=false},
        {label = "Poop", icon = 'poop', description='Time until you poop.',  progress=100 - math.floor(convertToPercentage(myHygienes['Poop'].iterationsUntil, Config.HygieneStatus['Poop'].iterationsUntil)), colorScheme='SaddleBrown', iconColor='SaddleBrown', iconAnimation='beat', close=false}
    }
    if myHygienes then
        for k,v in pairs(myHygienes) do
            if v.hasThis  then
                if k ~= 'Poop' and k ~= 'Pee' then
                    if v.canFade then
                        hygienes[#hygienes+1] = {label = k, icon = 'star-of-life', description = 'Time till gone.', progress=math.floor(convertToPercentage(v.canFade.iterations, Config.HygieneStatus[k].canFade.iterations)), colorScheme='DarkSlateGrey', iconAnimation='beat', close=false}
                    else
                        hygienes[#hygienes+1] = {label = k, description =k, icon = 'star-of-life',  progress=100, colorScheme='DarkSlateGrey',  close=false}
                    end
                end
            end
        end
    end

    lib.setMenuOptions('hygiene', hygienes)
    lib.showMenu('hygiene')
end)
