function(_GetCurrentTime CurTime)
    execute_process(COMMAND date +"%Y-%m-%d %H:%M:%S"
            OUTPUT_VARIABLE cur_time_string
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
    string(REPLACE "\"" "" CUR_TIME ${cur_time_string})

    set(${CurTime} ${CUR_TIME} PARENT_SCOPE)
endfunction()