local args = {...}
local directory = args[1]
print('---directory---', directory)

local logging = require(directory .. '.logging.logging')
local dotalogging = require(directory..'.dotalogging')

local units = {
    logging=dotalogging
}

return units
