
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef struct {
	long long total;
	long long free;
	long long used;
	long long cache;
} sg_mem_stats;

sg_mem_stats *sg_get_mem_stats();
]]

function exports:get_mem_stats()
  return extract_fields( self.statgrab.sg_get_mem_stats(), "iiii",
      {"total", "free", "used", "cache"}
    )
end



ffi.cdef [[
typedef struct {
	long long total;
	long long used;
	long long free;
} sg_swap_stats;

sg_swap_stats *sg_get_swap_stats();
]]

function exports:get_swap_stats()
  return extract_fields( self.statgrab.sg_get_swap_stats(), "iii",
      {"total", "used", "free"}
    )
end


return exports
