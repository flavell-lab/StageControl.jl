"""
    set_zero(s::SerialPort)
Sets the current x, y position to 0, 0
"""
function set_zero(s::SerialPort)
    sp_return = write(s, "HERE X=0 Y=0\r")
    write_check_error(s, sp_return)

    nothing
end

"""
    get_position(s::SerialPort)
Returns the current x, y position (Int)
"""
function get_position(s::SerialPort)
    # example return_str: ":A 454902 -98089 "
    sp_return = write(s, "WHERE X Y\r")
    if sp_return == SP_OK
        return_str = LibSerialPort.readuntil(s, '\n')
        return_str = replace(return_str, '\0'=>"") # remove null characters

        return parse.(Int, split(lstrip(rstrip(return_str)[3:end])))
    else
        error(sp_return)
    end
end

"""
    move_relative(s::SerialPort, dx::Int, dy::Int)
Move (relative) the stage position
"""
function move_relative(s::SerialPort, dx::Int, dy::Int)
    sp_return = write(s, "MOVEI X=$dx Y=$dy\r")
    write_check_error(s, sp_return)

    nothing
end
