wifi.sta.sethostname("uopNodeMCU")
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="Wifi Name" 
station_cfg.pwd="Password"
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.connect()

mytimer = tmr.create()
mytimer:register(3000, 1, function() 
   if wifi.sta.getip()==nil then
        print("Connecting to AP...\n")
   else
        ip, nm, gw=wifi.sta.getip()
        mac = wifi.sta.getmac()
        rssi = wifi.sta.getrssi()
        print("IP Info: \nIP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw)
        print("MAC: ",mac)  
        print("RSSI: ",rssi,"\n")
--        post()
        crawl()
        
        mytimer:stop()
   end        
end)
mytimer:start()

function crawl()
--srv = net.createConnection(net.TCP, 0)
--srv:on("receive", function(sck, c) print(c) end)
---- Wait for connection before sending.
--
--srv:on("connection", function(sck, c)
--  -- 'Connection: close' rather than 'Connection: keep-alive' to have server
--  -- initiate a close of the connection after final response (frees memory
--  -- earlier here), https://tools.ietf.org/html/rfc7230#section-6.6
--  sck:send("GET /get HTTP/1.1\r\nHost: wttr.in\r\nConnection: close\r\nAccept: */*\r\n\r\n")
--end)
--srv:connect(80,"httpbin.org")
--url='http://wttr.in/'
--url= 'https://ebay.co.uk'
url='http://httpbin.org/ip'
--url='http://amazon.co.uk'
--try other urls and see why they can work or why not
print(url)
headers={['samplefile.txt'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36'}
--headers to avoid the website to recognise you as a robot
--the headers here is different from the default one
--you can check it in the httpBasic.lua file on Moodle

http.request(url,'GET',headers,'',function(code, data)
    if (code<0) then
      print("HTTP request failed")
      print(code)
    else
      print(code)
      print(data)
fileList = file.list()
print(type(fileList))
--mode can be 'w' 'r' 'a' 'r+' 'w+' 'a+'

for name,size in pairs(fileList) do
    print("File name: "..name.." with size of "..size.." bytes")
end
fobjr = file.open('samplefile.txt','r')
fobjr:writeline(code)
fobjr:write(data)
print(fobjr.readline())
print(file.getcontents('samplefile.txt'))

--fobjr:close()

    end
end)
end
--
--function post()
--http.post('http://httpbin.org/post',
--  'Content-Type: application/json\r\n',
--  'samplefile.txt',
--  function(code, data)
--    if (code < 0) then
--      print("HTTP request failed")
--    else
--      print(code)
--      print(data)
--fileList = file.list()
--print(type(fileList))
--
--for name,size in pairs(fileList) do
--    print("File name: "..name.." with size of "..size.." bytes")
--end
--
----mode can be 'w' 'r' 'a' 'r+' 'w+' 'a+'
--    fobjw = file.open('samplefile.txt','w')
--    fobjw:writeline('This is a test')
--    fobjw:write('Data Test')
--    print(fobjw.read())
--    print(fobjw.readline())
--    print(file.getcontents('samplefile.txt'))
--
--    end
--  end)
--end

