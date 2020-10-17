wifi.setmode(wifi.SOFTAP)   -- set AP parameter
config = {}
config.ssid = "UP837518"
config.pwd = "test1234"
wifi.ap.config(config)
bc = wifi.ap.getbroadcast()
print("AP Gateway Address: ",bc)

saved_mac = ""
login_mac = ""
local fobjw = file.open('user_data.txt','a+')

for k,v in pairs(file.list()) do 
 print("File Name: " .. k .. " Size: " .. v)
end

mytimer = tmr.create()
mytimer:register(3000, 1, function() 
table={}
table=wifi.ap.getclient()
print("AP IP Address: "..wifi.ap.getip())
clientCount = 0

for mac,ip in pairs(table) do
    clientCount = clientCount + 1
    print("Client No."..clientCount)
    print("MAC: ", mac)
    print("IP: ", ip)
    login_mac = mac
end

if clientCount>0 then
    mytimer:stop()
end
end)
mytimer:start()

pinLED = 4
gpio.mode(pinLED,gpio.OUTPUT)
svr = net.createServer(net.TCP)



login_cnt = 0

function handlelogin(sck, data)

  print("Mac Address:"..login_mac.."\n")
  print("Log In Attempt Count:"..login_cnt.."\n")
  login_cnt = login_cnt + 1
  

--update the html file for display in your browser
  html = '<html>\r\n<head>\r\n<title>Log In</title>\r\n</head>\r\n'
  html = html..'<body>\r\n<form action=\"/LED_OFF\" method=\"get\">\r\n'
--method is get here, listener will try to find the get info
  
  html = html.."&nbsp;ID:<input type=\"text\" name=\"userid\"><br>\r\n"
  html = html.."NAME:<input type=\"text\" name=\"username\"><br>\r\n"

  html = html.."<input type=\"submit\" value=\"submit\" >\r\n"
-- add the different button
  html = html.."</form>\r\n</body>\r\n</html>\r\n"
  sck:send(html)
end

function htmlUpdate(sck, data, flag)
  print("data:"..data)
  start_userid, end_userid = string.find(data, "userid")
  start_name, end_name = string.find(data, "username")
  pos_amp = string.find(data, "&")
  pos_http = string.find(data, " HTTP/1.1")
  user_id = string.sub(data, end_userid+2, pos_amp-1)
  username = string.sub(data, end_name+2, pos_http-1)
  print("userid: "..user_id.."\n")
  print("username: "..username.."\n")
 
--update the html file for display in your browser
  html = '<html>\r\n<head>\r\n<title>LED LAN Control</title>\r\n</head>\r\n'
  html = html..'<body>\r\n<h1>LED</h1>\r\n<p>Click the button below to switch LED on and off.</p>\r\n<form method=\"get\">\r\n'
--method is get here, listener will try to find the get info
  if flag then
--compare the boolean logic here and below in the receiver
  strButton = 'LED_OFF'
  else
  strButton = 'LED_ON'
   if login_cnt == 1 then
    print("First log in:"..login_mac.."\n")
    saved_mac = login_mac
   end
   if login_cnt > 1 then
    print("Log In Attempt!\n")
 
    if string.find(saved_mac, login_mac) then 
     strButton = 'DENIED'
     sck:send("Log in denied! You are going to log in several times!")
     sck:on("sent", function(conn) conn:close() end)
     print("LOG IN DENIED!\n")
    end
   end
  
  end
  if strButton ~= 'DENIED' then
      
      html = html.."<input type=\"button\" value=\""..strButton.."\" onclick=\"window.location.href='/"..strButton.."'\">\r\n"
    -- add the different button
      html = html.."</form>\r\n</body>\r\n</html>\r\n"
      sck:send(html)
   end
   
end

function setMode(sck,data)

--check what is the data received, and figure out why we find the match pattern in the string
  if string.find(data, "GET /LED_ON")  then
   htmlUpdate(sck, data, true)
   gpio.write(pinLED, gpio.HIGH)
  elseif string.find(data, "GET /LED_OFF") then
   htmlUpdate(sck, data, false)
   gpio.write(pinLED,gpio.LOW)
  elseif string.find(data, "GET /LOGIN_DENY") then
   sck:send("<h2>Log in denied! You are going to log in 2 times!</h2>")
   sck:on("sent", function(conn) conn:close() end)
  elseif string.find(data, "GET /") then
   handlelogin(sck, data)
   gpio.write(pinLED,gpio.LOW)
  else
--if no match is found then close the connection after sending a notice using the socket for the last will
   sck:send("<h2>Error, no matched string has been found!</h2>")
   sck:on("sent", function(conn) conn:close() end)
  end
end

if svr then
  svr:listen(80, function(conn)
--listen to the port 80 for http
--when the event of ‘data is received’ happens, run the setMode
  conn:on("receive", setMode)
  end)
end
