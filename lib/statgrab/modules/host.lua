
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef struct {
	char *os_name;
	char *os_release;
	char *os_version;
	char *platform;
	char *hostname;
	time_t uptime;
} sg_host_info;

sg_host_info *sg_get_host_info();
]]

function exports:get_host_info()
  return extract_fields( self.statgrab.sg_get_host_info(), "sssssi",
      {"os_name", "os_release", "os_version", "platform", "hostname", "uptime"}
    )
end



ffi.cdef [[
typedef struct {
	char *name_list;
	int num_entries;
} sg_user_stats;

sg_user_stats *sg_get_user_stats();
]]

function exports:get_user_stats()
  return extract_fields( self.statgrab.sg_get_user_stats(), "si",
      {"name_list", "num_entries"}
    )
end

return exports
