function[C] = paramOpt(realValue, modelValue, modelName,current, N)


simOpt = 0;
i = 0;

while ~simOpt
    
    if i <= N || err < 0.005
        
        sim('%d', modelName)
        J = mean((realValue - modelValue)^2);
        dib = mean(current);
        Kr = J/dib;
        K = Kr/mean(modelValue);
        
        
        
        i = i+1;
    else
        simOpt = 1;
    end
end

        

