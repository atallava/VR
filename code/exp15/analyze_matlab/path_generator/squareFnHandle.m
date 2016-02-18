function fun = squareFnHandle(freq,A)
    fun = @(x) A*square(freq*x);
end