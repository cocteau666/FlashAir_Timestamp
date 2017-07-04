local cjson = require "cjson"

-- timestamp from NICT
function getTimestampFromNICT()
    local b,c,h = fa.request("https://ntp-b1.nict.go.jp/cgi-bin/json")
    res = cjson.decode(b)
    return string.format("%d",res.st) 
end

-- save timestamp
function saveTime(timestamp)
    local year = os.date("%Y",timestamp)
    local month = os.date("%m",timestamp)
    local day = os.date("%d",timestamp)
    local hour = os.date("%H",timestamp)
    local min = os.date("%M",timestamp)
    local sec = os.date("%S",timestamp)

    year = year - 1980
    sec = bit32.lshift(sec,1)
    local ymd = bit32.bor(bit32.lshift(year,9),bit32.lshift(month,5),day)
    local hms = bit32.bor(bit32.lshift(hour,11),bit32.lshift(min,5),sec)

    fa.SetCurrentTime(ymd, hms)
end

-- return timestamp from internal clock
function getTimestamp()
    local timestamp = os.time()
    if (timestamp == 347036400) then
        timestamp = getTimestampFromNICT()
        saveTime(timestamp)
    end
    return timestamp
end

