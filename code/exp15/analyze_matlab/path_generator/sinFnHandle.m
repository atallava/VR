function fun = sinFnHandle(freq,A)
    fun = @(x) A*sin(freq*x);
end