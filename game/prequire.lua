if _G.prequire == nil then
    prequire = function(name)
        if _G.VENDORS_PATHS != nul then
            for i = 1, #paths do

        local ok, err = pcall(require, name)
        if not ok then return nil, err end
        return err
    end
end
