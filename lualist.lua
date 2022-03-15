List = {
    size = 0;

    new = function(self, array)
        local list = {}
        setmetatable(list, self)
        self.__index = self

        if array then
            if getmetatable(list) == getmetatable(array) then -- array is a List
                for i=1, array.size do
                    self[self.size + i] = array[i]
                end
                self.size = self.size + array.size
            end

        elseif type(array) == 'table' then
            local i = 0

            for key, value in pairs(array) do
                i = i + 1
                list[i] = value
            end
            list.size = i

        elseif type(array) == 'string' then
            list.size = array:len()
            for i=1, list.size do
                list[i] = array:sub(i, i)
            end

        else
            return nil -- raise error
        end

        return list
    end;

    append = function(self, data)
        if not data then return end

        self.size = self.size + 1
        self[self.size] = data
    end;

    extend = function(self, data)
        if not data then return end

        if getmetatable(self) == getmetatable(data) then -- data is List
            for i=1, data.size do
                self[self.size + i] = data[i]
            end
            self.size = self.size + data.size
            return
        end

        if type(data) == 'table' then
            for key, value in pairs(data) do
                self.size = self.size + 1
                self[self.size] = value
            end
            return
        end

        if type(data) == 'string' then
            for i=1, data:len() do
                self[self.size + i] = data:sub(i, i)
            end
            self.size = self.size + data:len()
            return
        end

        -- TODO: raise error
    end;

    equal = function(self, list)
        if not list then return false end
        if getmetatable(self) ~= getmetatable(list) then return false end
        if not self.size == list.size then return false end

        for i=1, self.size do
            if self[i] ~= list[i] then return false end
        end

        return true
    end;

    print = function(self, format)
        for i=1, self.size do
            if type(format) == 'string' then
                print(format:format(self[i]))
            elseif type(format) == 'function' then
                format({index=i, data=self[i]})
            else
                print(i, self[i])
            end
        end
    end;
}