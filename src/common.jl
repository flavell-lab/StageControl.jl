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

function get_port_list_info(;nports_guess::Integer=64)
    ports = StageControl.sp_list_ports()
    list_port = String[]
    list_desc = String[]
#     list_transport = String[]

    for port in unsafe_wrap(Array, ports, nports_guess, own=false)
        port == C_NULL && return list_port, list_desc

        push!(list_port, sp_get_port_name(port))
        push!(list_desc, sp_get_port_description(port))
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
