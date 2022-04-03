
function  [X] =  WSNM( Y, c1, c2 )
    p = .8;
    [U,SigmaY,V] =   svd(full(Y),'econ');    
    %PatNum       = size(Y,2);
    Temp         =   sqrt(max( diag(SigmaY).^2 - c1, 0 ));
    s = diag(SigmaY);
    s1 = zeros(size(s));
    
    for i=1:4
        W_Vec    =   c2./( Temp.^(1/p) + eps );               % Weight vector
        %W_Vec    =   (C*sqrt(PatNum)*NSig^2)./( Temp + eps );
       	s1       =   solve_Lp_w(s, W_Vec, p);
       	Temp     =   s1;
    end
    SigmaX = diag(s1);
    X =  U*SigmaX*V' ; 
return;
