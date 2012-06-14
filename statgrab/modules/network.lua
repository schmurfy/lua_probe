
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef struct {
	char *interface_name;
	long long tx;
	long long rx;
	long long ipackets;
	long long opackets;
	long long ierrors;
	long long oerrors;
	long long collisions;
	time_t systime;
} sg_network_io_stats;

sg_network_io_stats *sg_get_network_io_stats(int *entries);
sg_network_io_stats *sg_get_network_io_stats_diff(int *entries);
]]

function exports:get_network_io_stats()
  return extract_list(self, "sg_get_network_io_stats", "siiiiiii",
      {"interface_name", "tx", "rx", "ipackets", "opackets", "ierrors", "oerrors", "collisions"}
    )
end


ffi.cdef [[
typedef enum {
	SG_IFACE_DUPLEX_FULL,
	SG_IFACE_DUPLEX_HALF,
	SG_IFACE_DUPLEX_UNKNOWN
} sg_iface_duplex;

typedef struct {
	char *interface_name;
	int speed;	/* In megabits/sec */
	sg_iface_duplex duplex;
	int up;
} sg_network_iface_stats;

sg_network_iface_stats *sg_get_network_iface_stats(int *entries);
]]

local duplex_state = {
  [ffi.C.SG_IFACE_DUPLEX_FULL] = "full",
  [ffi.C.SG_IFACE_DUPLEX_HALF] = "half"
}

function exports:get_network_iface_stats()
  return extract_list(self, "sg_get_network_iface_stats", "siii",
      {"interface_name", "speed", "duplex", "up"},
      function(ret)
        ret.duplex = duplex_state[ret.duplex]
        return ret
      end
    )
end

return exports
