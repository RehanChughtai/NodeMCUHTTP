wifi.sta.sethostname("uopNodeMCU")
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="VM3980916" 
station_cfg.pwd="xcmz5qgVbjsh"
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
        crawl()
        mytimer:stop()
   end 
end)
mytimer:start()


function crawl()
srv = net.createConnection(net.TCP, 0)
srv:on("receive", function(sck, c) print(c) end)
-- Wait for connection before sending.

srv:on("connection", function(sck, c)
  -- 'Connection: close' rather than 'Connection: keep-alive' to have server
  -- initiate a close of the connection after final response (frees memory
  -- earlier here), https://tools.ietf.org/html/rfc7230#section-6.6
  sck:send("GET /get HTTP/1.1\r\nHost: wttr.in\r\nConnection: close\r\nAccept: */*\r\n\r\n")
end)
srv:connect(80,"httpbin.org")
--
--fobjw:writeline(code)
--  print(code)
--  print(data)   
--  fobjw:write(data)
--  fobjw:write('Write Complete in File')
--url='http://httpbin.org/ip'
--url='http://wttr.in/'
----url='http://www.amazon.co.uk'
----try other urls and see why they can work or why not
--print(url)
--headers={['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36'}
----headers to avoid the website to recognise you as a robot
----the headers here is different from the default one
----you can check it in the httpBasic.lua file on Moodle
--
--http.request(url,'GET',headers,'',function(code, data)
--    if (code<0) then
--      print("HTTP request failed")
--      print(code)
--    else
--      print(code)
--      print(data)
--    end
--end)
end
