


local statgrab = require('statgrab')
local utils = require('../utils')

stats = statgrab.new()

function pd(t)
  print( utils.dump(t) )
end

-- pd( stats.cpu:get_cpu_percents() )
-- pd( stats.cpu:get_cpu_stats() )
-- pd( stats.cpu:get_cpu_stats_diff() )
-- pd( stats.cpu:get_load_stats() )
-- 
-- pd( stats.host:get_host_info() )
-- pd( stats.host:get_user_stats() )
-- 
-- pd( stats.memory:get_mem_stats() )
-- pd( stats.memory:get_swap_stats() )

-- pd( stats.disk:get_fs_stats() )
-- pd( stats.disk:get_disk_io_stats() )

-- pd( stats.network:get_network_io_stats() ) -- crash
-- pd( stats.network:get_network_iface_stats() )

-- pd( stats.process:get_process_stats() ) -- crash
pd( stats.process:get_process_count() )

