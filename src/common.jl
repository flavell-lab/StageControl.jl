function flush_buffer(s::SerialPort)
    sp_flush(s.ref, SP_BUF_BOTH) == SP_OK
end

function write_check_error(s::SerialPort, sp_return)
    if sp_return == SP_OK
        return_str = LibSerialPort.readuntil(s, '\n')
        return_str = replace(return_str, '\0'=>"")
        return_str = strip(chomp(return_str))

        if return_str != ":A"
            error("Command returend error: $return_str")
        end
    else
        error("SP Error: $sp_return")
    end

    nothing
end
