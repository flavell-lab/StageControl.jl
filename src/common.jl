function check_sp_return(sp_return)
    if sp_return != SP_OK
        error("Serial port error: $sp_return")
    end

    nothing
end

function check_bytes_read(read_bytes)
    if read_bytes == 0
        error("0 bytes to read")
    end

    nothing
end

function flush_buffer(s::SerialPort)
    sp_return = sp_flush(s.ref, SP_BUF_BOTH)
    if sp_return != SP_OK
        error("SP Error: $sp_return")
    end
    
    read_bytes = bytesavailable(s)
    if read_bytes != 0
        error("Buffer not cleard")
    end
    nothing
end

function write_check_error(s::SerialPort, sp_return)
    check_sp_return(sp_return)

    read_bytes = bytesavailable(s)
    if read_bytes == 0
        error("0 bytes to read")
    end

    return_str = String(read(s, read_bytes))
    return_str = strip(chomp(return_str))
    if return_str != ":A"
        error("Command returend error: $return_str")
    end

    nothing
end

function get_port_list_info(;nports_guess::Integer=64)
    ports = LibSerialPort.sp_list_ports()
    list_port = String[]
    list_desc = String[]
#     list_transport = String[]

    for port in unsafe_wrap(Array, ports, nports_guess, own=false)
        port == C_NULL && return list_port, list_desc

        push!(list_port, LibSerialPort.sp_get_port_name(port))
        push!(list_desc, LibSerialPort.sp_get_port_description(port))
#         push!(list_transport, sp_get_port_transport(port))
    end

    sp_free_port_list(ports)

    list_port, list_desc
end

function find_stage_port(;nports_guess::Integer=64)
    list_port, list_desc = get_port_list_info(nports_guess=nports_guess)
    idx_port = findfirst(occursin.("STMicroelectronics Virtual COM Port",
        list_desc))

    list_port[idx_port]
end

function check_baud_rate(s::SerialPort, baud_rate=115200)
    sp_return = write(s, "CAN 32 84 60 0\r")
    check_sp_return(sp_return)

    sleep(0.001)
    read_bytes = bytesavailable(s)
    return_str = String(read(s, read_bytes))
    if !startswith(return_str, ":A")
        error("The command returned error")
    end

    current_baud_rate = parse(Int, split(":A  CAN 32 212 60 115200\n")[end])

    if current_baud_rate != baud_rate
        error("Baud rate is $current_baud_rate, not $baud_rate")
    end

    nothing
end
