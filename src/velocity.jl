function set_velocity_x(s::SerialPort, speed_x::Int)
    cmd = zeros(UInt8, 13)
    cmd[1] = 0x23 # CAN comamnd marker
    cmd[2] = 0x01 # stage x
    cmd[3] = 0x41 # command 65
    cmd[4] = 0x00
    cmd[5] = 0x0a # index 10 for the command
    cmd[6] = 0x00
    cmd[7] = 0x04 # number of bytes for data (8-11)
    cmd[8] = 0x00
    cmd[9] = speed_x & 0x000000ff
    cmd[10] = (speed_x & 0x0000ff00) >> 8
    cmd[11] = (speed_x & 0x00ff0000) >> 16
    cmd[12] = (speed_x & 0xff000000) >> 24
    cmd[13] = 0x0D # end

    write(s, cmd) == SP_OK
end

function set_velocity_y(s::SerialPort, speed_x::Int)
    cmd = zeros(UInt8, 13)
    cmd[1] = 0x23 # CAN comamnd marker
    cmd[2] = 0x02 # stage y
    cmd[3] = 0x41 # command 65
    cmd[4] = 0x00
    cmd[5] = 0x0a # index 10 for the command
    cmd[6] = 0x00
    cmd[7] = 0x04 # number of bytes for data (8-11)
    cmd[8] = 0x00
    cmd[9] = speed_x & 0x000000ff
    cmd[10] = (speed_x & 0x0000ff00) >> 8
    cmd[11] = (speed_x & 0x00ff0000) >> 16
    cmd[12] = (speed_x & 0xff000000) >> 24
    cmd[13] = 0x0D # end

    write(s, cmd) == SP_OK
end