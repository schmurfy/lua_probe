
local folderOfFile = debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]]
package.path = folderOfFile .."../?.lua;" .. folderOfFile .. "?.lua;".. package.path

local ffi = require('ffi')
utils = require('utils')

local exports = {}
local instance_methods = {}
local fmt = string.format

ffi.cdef [[
int sg_init(void);
int sg_snapshot();
int sg_shutdown();
int sg_drop_privileges(void);

typedef uint64_t time_t;
]]

local byte = string.byte

local type_string = string.byte("s")
local type_integer = string.byte("i")

local function convert_field(field_type, value)
  if field_type == type_string then
    if (value ~= nil) and (value > ffi.cast('char*', 0x10)) then
      return ffi.string(value)
    else
      return ""
    end
  else
    return value
  end
end

-- global helper for plugins

local helpers = {}

function extract_fields(cdata, types, fields)
  local ret = {}
  local k, n
  
  for n,k in ipairs(fields) do
    local v = convert_field( byte(types, n), cdata[k])
    ret[k] = v
  end
  
  return ret
end

function extract_list(self, func_name, types, fields, converter)
  local entries_count = ffi.new("int[1]")
  local ret = {}, n
  local entries = self.statgrab[func_name](entries_count)
  
  for n=0,entries_count[0] - 1 do
    local converted = extract_fields(entries[n], types, fields)
    if converter then
      converted = converter(converted)
    end
    table.insert(ret, converted)
  end
  
  return ret
end


function exports.new()
  local state = {
    statgrab = ffi.load(folderOfFile .. "ext/libstatgrab.so")
  }
  
  state.statgrab.sg_init()
  
  if( state.statgrab.sg_drop_privileges() ~= 0 ) then
    print("failed to drop privilegies")
  end
  
  instance_methods["cpu"] = setmetatable(require("modules/cpu"), {__index = state} )
  instance_methods["host"] = setmetatable(require("modules/host"), {__index = state} )
  instance_methods["disk"] = setmetatable(require("modules/disk"), {__index = state} )
  instance_methods["memory"] = setmetatable(require("modules/memory"), {__index = state} )
  instance_methods["network"] = setmetatable(require("modules/network"), {__index = state} )
  instance_methods["process"] = setmetatable(require("modules/process"), {__index = state} )
  
  return setmetatable(state, {__index = instance_methods})
end



return exports
