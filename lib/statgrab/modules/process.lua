
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef uint32_t  uid_t;
typedef uint32_t  gid_t;
typedef int32_t   pid_t;

/* Recommend to add SG_PROCESS_STATE_IDLE */
typedef enum {
	SG_PROCESS_STATE_RUNNING,
	SG_PROCESS_STATE_SLEEPING,
	SG_PROCESS_STATE_STOPPED,
	SG_PROCESS_STATE_ZOMBIE,
	SG_PROCESS_STATE_UNKNOWN
} sg_process_state;

typedef struct {
	char *process_name;
	char *proctitle;

	pid_t pid;
	pid_t parent; /* Parent pid */
	pid_t pgid;   /* process id of process group leader */

	uid_t uid;
	uid_t euid;
	gid_t gid;
	gid_t egid;

	unsigned long long proc_size; /* in bytes */
	unsigned long long proc_resident; /* in bytes */
	time_t time_spent; /* time running in seconds */
	double cpu_percent;
	int nice;
	sg_process_state state;
} sg_process_stats;

sg_process_stats *sg_get_process_stats(int *entries);
]]

local process_state = {
  [ffi.C.SG_PROCESS_STATE_RUNNING] = "run",
  [ffi.C.SG_PROCESS_STATE_SLEEPING] = "sleep",
  [ffi.C.SG_PROCESS_STATE_STOPPED] = "stop",
  [ffi.C.SG_PROCESS_STATE_ZOMBIE] = "zombie"
}

function exports:get_process_stats()
  return extract_list(self, "sg_get_process_stats", "ssiiiiiiiiiifii",
      {"process_name", "proctitle", "pid", "parent", "pgid", "uid", "euid", "gid", "egid", "proc_size", "proc_resident", "time_spent", "cpu_percent", "nice", "state"},
      function(ret)
        ret.state = process_state[ret.state]
        return ret
      end
    )
end


ffi.cdef [[
typedef struct {
	int total;
	int running;
	int sleeping;
	int stopped;
	int zombie;
} sg_process_count;

sg_process_count *sg_get_process_count();
]]

function exports:get_process_count()
  return extract_fields( self.statgrab.sg_get_process_count(), "iiiii",
      {"total", "running", "sleeping", "stopped", "zombie"}
    )
end

return exports
