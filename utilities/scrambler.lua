local scrambler = {}
local charset = {"²","","","¶","G","j","±","","ú","n","Ñ","©","Ä","\\","º","P","|","v","3","Ì","","$","W","","-","¥","ù","","Â","æ","w","Ê","ÿ","*","ß","L","B","","³","m","½","R","","","Ø","µ","T","x","7","Z","¢","ç","Ë","¼","V","Î","","Ö","À","Õ","Ô","Û","Ý","Þ"}

function scrambler:Generate(length)
	local buffer = table.create(length)
	for i = 1, length do
		buffer[i] = charset[math.random(#charset)]
	end
	return table.concat(buffer)
end

return scrambler
