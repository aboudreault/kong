local utils = require("kong.timer.utils")

local assert = utils.assert

local _M = {
    DEFAULT_THREADS = 32,

    -- restart the thread after every 50 jobs have been run
    DEFAULT_RESTART_THREAD_AFTER_RUNS = 50,

    DEFAULT_FOCUS_UPDATE_TIME = true,

    -- 23 hour 59 minute 00 second
    MAX_EXPIRE = 23 * 60 * 60 + 59 * 60,

    -- 100ms
    RESOLUTION = 0.1,

    -- 100ms per slot
    MSEC_WHEEL_SLOTS = 10,

    -- 1 second per slot
    SECOND_WHEEL_SLOTS = 60,

    -- 1 minute per slot
    MINUTE_WHEEL_SLOTS = 60,

    -- 1 hour per slot
    HOUR_WHEEL_SLOTS = 24,

    MSG_FATAL_FAILED_CREATE_NATIVE_TIMER
        = "failed to create a native timer: "
}


local meta_table = { __index = _M }

setmetatable(_M, meta_table)


-- 100ms * 10 = 1 second
assert(_M.RESOLUTION * _M.MSEC_WHEEL_SLOTS == 1,
    "perhaps you need to update the constants " ..
    "`RESOLUTION` and `MSEC_WHEEL_SLOTS`")


-- `-10` means don't touch the boundary, i.e. 23 hour 59 minute 00 second
-- you can also change it to `-2` (min)
local _max_expire = _M.RESOLUTION
    * _M.MSEC_WHEEL_SLOTS
    * _M.SECOND_WHEEL_SLOTS
    * _M.MINUTE_WHEEL_SLOTS
    * _M.HOUR_WHEEL_SLOTS
    - 10

-- `MAX_EXPIRE` should not exceed the maximum supported range of the wheels
assert(_M.MAX_EXPIRE < _max_expire,
    "perhaps you need to update some constants")

return _M