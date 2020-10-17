--delete put post will be tested here
--please note that they can not be concurrent requests
--please check the format of the received data
--visit the url directly in your web browsers
--to see if your visiting will fail
--and see what a HTTP request method is
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
        --post()
        --put()
        delete()
        --can not be concurrent requests
        --comment out 2 and execute 1
        mytimer:stop()
   end        
end)
mytimer:start()

--function post()
--http.post('http://httpbin.org/post',
--  'Content-Type: application/json\r\n',
--  '{"IoT":"2020","This is":"Json Format","Please check":'..
--  '"How the data are shaped"}',
--  function(code, data)
--    if (code < 0) then
--      print("HTTP request failed")
--    else
--      print(code)
--      print(data)
--    end
--  end)
--end

--function put()
--http.put('http://httpbin.org/put',
--  'Content-Type: text/plain\r\n',
--  'IoT 2020 plain text, please check how the data are formatted',
--  function(code,data)
--    if (code < 0) then
--      print("HTTP request failed")
--    else
--      print(code)
--      print(data)
--    end
--  end)
--end
--
function delete()
http.delete('http://httpbin.org/delete',
  "IoT",
  "IoT",
  function(code,data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code)
      print(data)
    end
  end)
end
