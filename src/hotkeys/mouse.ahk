; mouse right scroll button
F22::WheelRight

; mouse left scroll button
F23::WheelLeft

; under-mouse button
F24::
    WinGet, active_pid, PID , A
    Process, Close, %active_pid%
return