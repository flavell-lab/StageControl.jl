module StageControl

using LibSerialPort

include("position.jl")
include("velocity.jl")
include("common.jl")

export set_zero,
    get_position,
    move_relative,
    move_absolute,
    # velocity.jl
    set_velocity_x,
    set_velocity_y,
    # common.jl
    flush_buffer
end # module
