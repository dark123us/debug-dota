local function extract_rows(rows, row, data, shift)
	if type(data) == 'table' then
		if data[1] ~= nil then
			rows[#rows+1] = row
			for _, vd in pairs(data) do
				rows[#rows+1] = shift..vd
			end
			row = shift;
		end
	else
		row = row..data
	end
	return row
end

local function get_table(t, indent, showlevel, done)
	if type(t) ~= "table" then return tostring(t) end
	if showlevel < 1 then return '...' end
	done[t] = true -- deprecated recursion __index
	local l = {}
	for k, v in pairs(t) do
		if k ~= 'FDesc' then
			table.insert(l, k)
		end
	end
	table.sort(l)

	local rows = {}
	local row = ''
	local shift = string.rep(' ', indent)
	local shift2 = string.rep(' ', indent-2)
	local shift3 = string.rep(' ', indent+2)
	local data

	for _, k in ipairs(l) do
		local v = t[k]
		row = shift..k.." = ("..type(v)..") "
		if type(v) == 'table' and not done[v] then
			done[v] = true
			row = row..'{'
			data = get_table(v, indent+2, showlevel-1, done)
			row = extract_rows(rows, row, data, shift2)
			if getmetatable(v) ~= nil then
				rows[#rows+1] = row
				row = shift3..'getmetatable = {'
				data = get_table(getmetatable(v), indent, showlevel-1, done)
				row = extract_rows(rows, row, data, shift3)..'}'
				rows[#rows+1] = row
				row = shift
			end
			row = row..'}'
		elseif type(v) == 'userdata' and not done[v] then
			done[v] = true
			local meta = (getmetatable(v) and getmetatable(v).__index) or getmetatable(v)
			if meta ~= nil then
				row = row..'= {'
				data = get_table(meta, indent+4, showlevel-1, done)
				row = extract_rows(rows, row, data, shift3)
				rows[#rows+1] = row..'}'
				row = shift
			else
				row = row..tostring(v)
			end
		else
			if t.FDesc and t.FDesc[k] then
				row = row..tostring(v)..' FDesc'
				-- local meta = (getmetatable(t.FDesc[k]) and getmetatable(t.FDesc[k]).__index) or getmetatable(t.FDesc[k])
				-- rows[#rows+1] = row..tostring(v)..' FDesc '..type(t.FDesc[k])..tostring(meta)
				-- row = shift..tostring(t.FDesc[k])
			else
				row = row..tostring(v)
			end
		end
		rows[#rows+1] = row
	end
	return rows
end

local function printTable(t, asString, showlevel)
    asString = asString or true
	if type(t) ~= "table" then
        if asString then
            return tostring(t)
        end
        print(tostring(t))
        return
    end
	showlevel = showlevel or 7
    local res = ""
    if asString then
        res = res .. '\n{\n'
    else
	    print '{'
    end
	local rows = get_table(t, 2, showlevel, {})
    
	for _, row in pairs(rows) do
        if asString then
            res = res .. row .. '\n'
        else
            print(row)
        end
		
	end
    if asString then
        res = res .. '}'
    else
	    print '}'
    end
    return res
end

return printTable