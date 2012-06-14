
local exports = {}

local fmt = string.format
local floor = math.floor

local function get_time(t)
  t = t or os.time()
  return os.date("!%Y-%m-%dT%H:%M:%S", t)
end

local function convert_number(n)
  local ref = floor(n)
  
  if n == ref then
    return fmt("%d", n)
  else
    return fmt("%f", n)
  end
end

local type_matrix = {
  counter = "c",
  derive  = "d",
  delta   = "d"
}

-- ESTP:org.example:sys::cpu: 2012-06-02T09:36:45 10         7.2
function exports.build_request(host, app_name, resource_name, metric_name, value, interval, type, time)
  interval = interval or 10
  
  local ret = fmt("ESTP:%s:%s:%s:%s: %s %d ",
      host, app_name, resource_name, metric_name, get_time(time), interval
    )
  
  ret = ret .. convert_number(value)
  
  local estp_type = type_matrix[type]
  if estp_type then
    ret = ret .. ":" .. estp_type
  end
  
  return ret
end

return exports
