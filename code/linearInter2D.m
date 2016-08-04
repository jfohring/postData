function [Tc,dT] = linearInter2D(T,X,param,varargin)
%  function [Tc,dT] = linearInter2D(T,X);

doDerivative = (nargout>2);
dT = [];
%overwrite defaults
for k=1:2:length(varargin),     % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

% get dimensions m, cell size h, and number n of interpolation points 
h = param.h; 
m = param.m;
n = prod(m);

T = reshape(T,m);

% map X from [h/2,omega-h/2] -> [1,m]
X  = X*diag(1./h) + 0.5;             
% initialize output
Tc = zeros(n,1); 

Valid = @(j) (0<X(:,j) & X(:,j)<m(j)+1);  
valid = find( Valid(1) & Valid(2) );                
                    
% pad data to reduce cases
pad = 1; 
TP = zeros(m+2*pad); 
TP(pad+(1:m(1)),pad+(1:m(2))) = T;
% splitt X into integer/remainder
P = floor(X); X = X-P;                    
p = @(j) P(valid,j); xi = @(j) X(valid,j);
% increments for linearized ordering
i1 = 1; i2 = size(TP,1);                  
p  = (pad + p(1)) + i2*(pad + p(2) - 1);

% compute Tc as weighted sum
Tc(valid) = (TP(p)   .* (1-xi(1)) + TP(p+i1)    .*xi(1)) .* (1-xi(2)) ...
         + (TP(p+i2) .* (1-xi(1)) + TP(p+i1+i2) .*xi(1)) .* (xi(2));

if not(doDerivative), return; end;
dT = zeros(n,2);
% determine indices of valid points
if isempty(valid), 
  dT = sparse(n,2*n);
  return; 
end;

dT(valid,1) = (TP(p+i1)-TP(p)).*(1-xi(2)) + (TP(p+i1+i2)-TP(p+i2)).*xi(2);
dT(valid,2) = (TP(p+i2)-TP(p)).*(1-xi(1)) + (TP(p+i1+i2)-TP(p+i1)).*xi(1);
dT(:,1) = dT(:,1)/h(1);  dT(:,2) = dT(:,2)/h(2);
dT = spdiags(dT,[0,n],n,2*n);
