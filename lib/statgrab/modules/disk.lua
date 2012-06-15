
local ffi = require('ffi')

local exports = {}

ffi.cdef [[
typedef struct {
	char *device_name;
	char *fs_type;
	char *mnt_point;
	long long size;
	long long used;
	long long avail;
	long long total_inodes;
	long long used_inodes;
	long long free_inodes;
	long long avail_inodes;
	long long io_size;
	long long block_size;
	long long total_blocks;
	long long free_blocks;
	long long used_blocks;
	long long avail_blocks;
} sg_fs_stats;

sg_fs_stats *sg_get_fs_stats(int *entries);
]]


function exports:get_fs_stats()
  return extract_list(self, "sg_get_fs_stats", "sssiii",
      {"device_name", "fs_type", "mnt_point", "size", "used", "avail"}
    )
end



ffi.cdef [[
typedef struct {
	char *disk_name;
	long long read_bytes;
	long long write_bytes;
	time_t systime;
} sg_disk_io_stats;

sg_disk_io_stats *sg_get_disk_io_stats(int *entries);
sg_disk_io_stats *sg_get_disk_io_stats_diff(int *entries);
]]

function exports:get_disk_io_stats()
  return extract_list(self, "sg_get_disk_io_stats", "sii",
      {"disk_name", "read_bytes", "write_bytes"}
    )
end

return exports
