function is_stage_moving(s::SerialPort)
    sp_return = write(s, "STATUS\r")
    if sp_return != SP_OK
        error("Write returned error $sp_return")
    end

    # fix timing
    read_bytes = bytesavailable(s)
    if read_bytes != 1
        error("Bytes to read should be 1 (instead $read_bytes)")
    end

    return_char = read(s, 1)[1]
    if return_char == 0x4e
        return false
    elseif return_char == 0x42
        return true
    else
        error("STATUS should return 0x4e or 0x42 (instead $return_char)")
    end
end
