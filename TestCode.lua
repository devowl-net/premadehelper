http://stackoverflow.com/questions/14068944/attempt-to-index-local-self-a-nil-value
-- inside foo()
-- these two are analogous
self:bar()
self.bar(self)


http://stackoverflow.com/questions/22123970/in-lua-how-to-get-all-arguments-including-nil-for-variable-number-of-arguments
-- ѕечатаем все параметра которые идут через зап€тую New("1", "2"); если функа с : то в 1-м параметре будет self
function table.pack(...)
   return { n = select("#", ...); ... }
end

function show(...)
   local string = ""
   
   local args = table.pack(...)
   
   for i = 1, args.n do
      string = string .. tostring(args[i]) .. " "
   end
   
   return string .. " "
end


https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
-- –аспечатать значени€ таблицы.
for k, v in pairs( myTable ) do
   print(k, v)
end


--[[
http://www.wowinterface.com/forums/showthread.php?t=50295
When you register a UNIT_* event on a frame in oUF, it ties the unit the event fires for to the unit associated with the frame.
So, if you register say UNIT_HEALTH on your player frame, the function will only fire if the event fired for the player unit.
The 3rd argument to frame:RegisterEvent() is to override this check, which is why the argument is called "unitless"

See this source for more details:
https://github.com/haste/oUF/blob/ma...s.lua#L53-L100

In the past, oUF's event handler checked everything itself, but somewhere during Cata or Mists we got a new method called 
RegisterUnitEvent to do this work for us, and is what oUF uses today. 
]]--