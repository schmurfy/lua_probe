
local socket = require("socket")

local statgrab = require('statgrab/statgrab')
local estp = require('protocols/estp')
local utils = require('../utils')

local byte = string.byte


local interval = 2
local client = socket.udp()
local started_at, delay
local stats = statgrab.new()

local metric_types = {
  [byte("c")] = "counter",
  [byte("d")] = "derive"
}


local hostname = "localhost"
local destination_address = "127.0.0.1"
local destination_port = 4000

local function send_statgrab_stat(cl, mod_name, func_name, types, fields)
  local n,v
  local type, req
  
  local t = stats[mod_name][func_name](stats)
  
  for n,v in ipairs(fields) do
    metric_type = metric_types[byte(types, n)]
    req = estp.build_request(hostname, "system", mod_name, v, tonumber(t[v]), interval, metric_type)
    cl:sendto(req, destination_address, destination_port)
  end
  
end

while 1 do
  started_at = socket.gettime()
  
  -- collect and send them
  local cpu_stats = stats.cpu:get_cpu_stats()
  
  send_statgrab_stat(client, "cpu", "get_cpu_stats", "ggggggg", {"user", "kernel", "idle", "iowait", "swap", "nice", "total"} )
  
  -- and wait the remaining time
  delay = interval - (socket.gettime() - started_at)
  print("Waiting for " .. delay .. " seconds")
  socket.sleep(delay)
end

