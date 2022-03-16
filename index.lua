-- https://github.com/violencedev/mtasalua-betterstrings

function to_array(instring)
    local str_Table = {}
    for i = 1, #instring do 
        str_Table[i] = instring:sub(i, i)
    end 
    return str_Table
end 

function from_array(inarray)
    local text = ''
    for i = 1, #inarray do 
        text = text .. inarray[i]
    end 
    return text 
end 

local Public = {

    capitalize = function(self)
        return self.value:upper()
    end;

    count = function(self, inelement)
        local chars = string.gmatch(self.value, inelement)
        local i = 0
        for char in chars do 
            i = i + 1
        end 
        return i
    end;

    reverse = function(self)
        local base_table = to_array(self.value)
        local reversed_table = {}
        for j = #base_table, 1, -1 do 
            reversed_table[#self.value - j + 1] = base_table[j]
        end 
        local reversed_str = from_array(reversed_table)
        return reversed_str
    end;
    
    startswith = function(self, inelement)
        return self.value:sub(1, #inelement) == inelement 
    end;
    
    endswith = function(self, inelement)
        return self.value:sub(#self.value - #inelement + 1, #self.value) == inelement
    end; 
    
    indexOf = function(self, inelement)
        if type(self.value) == 'string' then self.value = to_array(self.value) end 
        for key, value in pairs(self.value) do 
            if value == inelement then return key end 
        end 
        return nil
    end;
    
    slice = function(self, startIndex, endIndex)
        if type(self.value) == 'string' then self.value = to_array(self.value) end 
        return {table.unpack(self.value, startIndex or 1,endIndex or #self.value)} 
    end;
    
    isalnum = function(self)
        local i = 0
        for _,v in string.gmatch(self.value, '%w') do 
            i = i + 1
        end 
        return i == #self.value
    end;
    
    isalpha = function(self)
        local i = 0
        for _,v in string.gmatch(self.value, '%a') do 
            i = i + 1
        end 
        return i == #self.value    
    end;
    
    isdigit = function(self)
        local i = 0
        for _,v in string.gmatch(self.value, '%d') do 
            i = i + 1
        end 
        return i == #self.value
    end;
    
    islower = function(self)
        return string.lower(self.value) == self.value 
    end;
    
    isupper = function(self)
        return string.upper(self.value) == self.value
    end;
    
    replace = function(self, old, new, count)
        if type(self.value) == 'string' then self.value = to_array(self.value) end 
        if not tonumber(count) then count = nil end 
        return string.gsub(self.value, old, new, count)
    end;
    
    strip = function(self, chars)
        if not chars then chars = {' '} else chars = to_array(chars) end 
        local intable = to_array(self.value)
        for i = #intable, 1, -1 do 
            v = intable[i]
            if indexOf(chars, v) then 
                table.remove(intable, i)
            end 
        end 
        return from_array(intable)
    end;
    
    swapcase = function(self)
        local array = to_array(self.value)
        for k, v in pairs(array) do 
            if islower(v) == true then array[k] = string.upper(v) end 
            if isupper(v) == true then array[k] = string.lower(v) end 
        end 
        return from_array(array)
    end;
    
    title = function(self)
        local words = split(self.value, ' ')
        for key, word in pairs(words) do 
            words[key] = capitalize(word)
        end 
        return table.concat(words, ' ')
    end;
    
    any = function(inarray)
        return indexOf(inarray, 'true') 
    end;
    
    all = function(inarray)
        return count(inarray, 'true') == #inarray 
    end;
    
    filter = function(self, initerable)
        if type(initerable) == 'string' then initerable = to_array(initerable) end
        local returned = {} 
        for _,v in pairs(initerable) do 
            if self.value(v) == true then table.insert(returned, v) end
        end 
        return returned; 
    end;
    
    tableExpand = function(self)
        z = {}
        n = 0
        for _,v in ipairs(self.value[1]) do n=n+1; z[n]=v end
        for _,v in ipairs(self.value[2]) do n=n+1; z[n]=v end
        return z
    end;
    
    zip = function(...)
        local arrays, ans = {...}, {}
        local index = 0
        return
        function()
            index = index + 1
            for i,t in ipairs(arrays) do
                if type(t) == 'function' then ans[i] = t() else ans[i] = t[index] end
                if ans[i] == nil then return end
            end
            return unpack(ans)
        end
    end;
}

local instance = setmetatable(Public, {
    __call = function(self, value, args)

        self.args = args
        self.value = value

        return self
    end
})

module.exports("stringfy", instance)
