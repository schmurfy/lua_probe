
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef struct {
	long long user;
	long long kernel;
	long long idle;
	long long iowait;
	long long swap;
	long long nice;
	long long total;
	time_t systime;
} sg_cpu_stats;

sg_cpu_stats *sg_get_cpu_stats();
sg_cpu_stats *sg_get_cpu_stats_diff();
]]

function exports:get_cpu_stats()
  return extract_fields( self.statgrab.sg_get_cpu_stats(), "iiiiiii",
      {"user", "kernel", "idle", "iowait", "swap", "nice", "total"}
    )
end


function exports:get_cpu_stats_diff()
  return extract_fields( self.statgrab.sg_get_cpu_stats_diff(), "iiiiiii",
      {"user", "kernel", "idle", "iowait", "swap", "nice", "total"}
    )
end

ffi.cdef [[
typedef struct {
	float user;
	float kernel;
	float idle;
	float iowait;
	float swap;
	float nice;
	time_t time_taken;
} sg_cpu_percents;

sg_cpu_percents *sg_get_cpu_percents();
]]

function exports:get_cpu_percents()
  return extract_fields( self.statgrab.sg_get_cpu_percents(), "ffffff",
      {"user", "kernel", "idle", 'iowait', "swap", "nice"}
    )
end


ffi.cdef [[
typedef struct {
	double min1;
	double min5;
	double min15;
} sg_load_stats;

sg_load_stats *sg_get_load_stats();
]]

function exports:get_load_stats()
  return extract_fields( self.statgrab.sg_get_load_stats(), "fff",
      {"min1", "min5", "min15"}
    )
end

return exports
