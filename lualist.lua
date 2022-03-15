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

    insert = function(self, index, value)
        if index == 0 then
            index = 1
        elseif index < 0 then -- backwards indexing
            if index < self.size * -1 then return end -- TODO: raise index error
            index = self.size + index + 1
        elseif index > self.size + 1 then
            return -- TODO: raise index error
        end

        for i=self.size, index, -1 do
            self[i+1] = self[i]
        end

        self[index] = value
        self.size = self.size + 1
    end;

    remove = function(self, value)
        if not value then return false end -- TODO raise ValueError
        local i = 1
        while i <= self.size do
            if self[i] == value then break end
            i = i + 1
        end

        if i > self.size then return false end -- TODO raise ValueError

        while i <= self.size do
            self[i] = self[i+1]
            i = i + 1
        end

        self.size = self.size - 1

        return true
    end;

    pop = function(self, index)
        index = index or self.size
        if index == 0 then
            index = 1
        elseif index < 0 then
            if index < self.size * -1 then return nil end -- TODO: raise index error
            index = self.size + index + 1
        end

        local value = self[index]
        for i=index, self.size do
            self[i] = self[i+1]
        end

        self.size = self.size - 1

        return value
    end;

    clear = function(self)
        for i=1, self.size do
            self[i] = nil
        end
        self.size = 0
    end;

    index = function(self, value, start, stop)
        if not start or start == 0 then start = 1 end
        if start < 0 then
            if start < self.size * -1 then return nil end -- TODO: raise index error
            start = self.size + start + 1
        end

        stop = stop or self.size
        if stop < 0 then
            if stop < self.size * -1 then return nil end -- TODO: raise index error
            stop = self.size + stop + 1
        end

        if stop < start then return nil end -- TODO: raise index error

        for i=start, stop do
            if getmetatable(self[i]) == getmetatable(self) then
                if (self[i]:equal(value)) then return i end
            elseif self[i] == value then
                return i
            end
        end

        return nil
    end;

    count = function(self, value)
        local count = 0
        for i=1, self.size do
            if getmetatable(value) == getmetatable(self) and getmetatable(value) == getmetatable(self[i]) then -- is List
                if self[i]:equal(value) then
                    count = count + 1
                end
            else
                if self[i] == value then
                    count = count + 1
                end
            end
        end

        return count
    end;

    reverse = function(self)
        local copy = self:copy()

        self:clear()

        while copy.size > 0 do
            self:append(copy:pop())
        end
    end;

    copy = function(self) -- shallow copy
        return List:new(self)
    end;

    sort = function(self, sort_func)
        -- TODO: sorter        
    end;

    equal = function(self, list)
        if not list then return false end
        if getmetatable(self) ~= getmetatable(list) then return false end
        if not self.size == list.size then return false end

        for i=1, self.size do
            if self[i] ~= list[i] then return false end
        end

        return true
    end
}