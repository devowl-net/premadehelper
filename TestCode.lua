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