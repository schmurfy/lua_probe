local ffi = require('ffi')

local slen = string.len

local server_port = 4000

ffi.cdef [[
typedef	uint16_t  in_port_t;
typedef	uint32_t  in_addr_t;
typedef uint32_t  socklen_t;

typedef long  ssize_t;
typedef unsigned long  size_t;

/*
 * Internet address (a structure for historical reasons)
 */
struct in_addr {
	in_addr_t s_addr;
};
]]




if ffi.os == "Linux" then
  ffi.cdef [[
    typedef uint16_t   sa_family_t;
    
    struct sockaddr_in {
    	sa_family_t	sin_family;
    	in_port_t	sin_port;
    	struct	in_addr sin_addr;
    	char		sin_zero[8];
    };

    struct sockaddr {
    	sa_family_t	sa_family;	/* [XSI] address family */
    	char		sa_data[14];	/* [XSI] addr value (actually larger) */
    };
    
  ]]
elseif (ffi.os == "OSX") or (ffi.os == "BSD") then
  ffi.cdef [[
    typedef uint8_t   sa_family_t;
    
    struct sockaddr_in {
    	uint8_t	sin_len;
    	sa_family_t	sin_family;
    	in_port_t	sin_port;
    	struct	in_addr sin_addr;
    	char		sin_zero[8];
    };

    struct sockaddr {
    	uint8_t	sa_len;		/* total length */
    	sa_family_t	sa_family;	/* [XSI] address family */
    	char		sa_data[14];	/* [XSI] addr value (actually larger) */
    };
  ]]
end


ffi.cdef [[

int socket(int domain, int type, int protocol);
int bind(int socket, const struct sockaddr *address, socklen_t address_len);
ssize_t sendto(int socket, const void *buffer, size_t length, int flags, const struct sockaddr_in *dest_addr, socklen_t dest_len);


uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
unsigned int sleep(unsigned int seconds);
int inet_aton(const char *cp, struct in_addr *pin);

char *strerror(int errnum);
]]

local AF_INET = 2;
local SOCK_DGRAM = 2;
local INADDR_ANY = 0

-- local s = ffi.C.socket(AF_INET, SOCK_DGRAM, 0)
-- if s == -1 then
--   print("ERROR")
-- end
-- 
-- local serv_addr = ffi.new("struct sockaddr_in")
-- 
-- serv_addr.sin_family = AF_INET;
-- serv_addr.sin_addr.s_addr = ffi.C.htonl(INADDR_ANY);
-- serv_addr.sin_port = ffi.C.htons(server_port);
-- 
-- local rc = ffi.C.bind(s, serv_addr, ffi.sizeof(serv_addr));
-- if rc < 0 then
--   print("ERROR")
-- end
-- 
-- print("Listening on port ".. server_port)
-- 
-- while 1 do
--   ffi.C.sleep(1);
-- end



local exports = {}
local instance_methods = {}

-- internal utility
local function error_string()
  return ffi.string(ffi.C.strerror( ffi.errno() ))
end

function cerror(msg)
  print(msg .. ": " .. error_string() .. " (" .. ffi.errno() ..")")
end

-- utility
ffi.cdef [[
typedef uint32_t useconds_t;
int usleep(useconds_t useconds);
]]
function exports.sleep(n)
  ffi.C.usleep(n * 1000000)
end


ffi.cdef [[
typedef long __darwin_time_t;
typedef int32_t __darwin_suseconds_t;

struct timeval {
	__darwin_time_t		tv_sec;		/* seconds */
	__darwin_suseconds_t	tv_usec;	/* and microseconds */
};

int gettimeofday(struct timeval *restrict tp, void *restrict tzp);
]]

function exports.gettime()
  local tv = ffi.new("struct timeval")
  
  ffi.C.gettimeofday(tv, nil);
  
  return tv.tv_sec + tv.tv_usec / 1.0e6;
end



-- Class
function exports.new(socket_type)
  local state = {
    bound = false,
    socket = ffi.C.socket(AF_INET, SOCK_DGRAM, 0)
  }
  
  if state.socket == -1 then
    cerror("Unable to create socket")
  end
  
  return setmetatable(state, {__index = instance_methods})
end


function exports.udp()
  return exports.new("udp")
end

-- function instance_methods:bind(port)
--   local local_addr = ffi.new("struct sockaddr_in")
-- 
--   local_addr.sin_family = AF_INET;
--   local_addr.sin_addr.s_addr = ffi.C.htonl(INADDR_ANY);
--   local_addr.sin_port = ffi.C.htons(port);
-- 
--   local rc = ffi.C.bind(s, local_addr, ffi.sizeof(local_addr));
--   if rc < 0 then
--     cerror("Unable to bind on port " .. port)
--   end
--   
--   self.bound = true
-- end


function instance_methods:sendto(payload, dest_addr, dest_port, payload_len)
  payload_len = payload_len or slen(payload) + 1
  local sa_dest_addr = ffi.new("struct sockaddr_in[1]")
  ffi.fill(sa_dest_addr, ffi.sizeof(sa_dest_addr))
  
  sa_dest_addr[0].sin_family = AF_INET
  sa_dest_addr[0].sin_port = ffi.C.htons(dest_port)
  
  if ffi.C.inet_aton(dest_addr, sa_dest_addr[0].sin_addr) == 0 then
    cerror("Unable to convert address: " .. dest_addr)
  end
  
  local sent = ffi.C.sendto(self.socket, payload, payload_len, 0, sa_dest_addr, ffi.sizeof(sa_dest_addr))
  if sent == -1 then
    cerror("Unable to send packet")
  end
  
end



-- return exports;


local s = exports.new()
print(exports.gettime());
while 1 do
  print("Sending packet")
  s:sendto("Hello !\n", "127.0.0.1", 4000)
  exports.sleep(1)
end