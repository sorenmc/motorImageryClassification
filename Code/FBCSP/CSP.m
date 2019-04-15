function w = CSP(miData,m,a,b)
% DESCRIPTION OF FUNCTION
%
% Given a structure miData containing motor imagery data, and m 
% that specifies how many filters to take from the CSP, returns the 
% m CSP filter to spatially discriminate between class a and b
%
% INPUT
%
% miData:           Structure that contains MI snippets and corresponding
%                   information.
%
% m:                2*m is the number of filters to take from the CSP
%                   matrix (1 from each end of the matrix to maximize
%                   variance)
%
% a:                class 1
% b:                class 2
%
% OUTPUT:
%
% w:                The CSP filters that will be returned, and used for
%                   evaluation data
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

%find convariance matrixes
[Ra,Rb] = covarianceMatrix(miData,a,b);

%Find the covariances mutual eigenvectors, and compute P
[U,D] = eig(0.5*(Ra+Rb));
P = (inv(D).^(0.5))*transpose(U);

%From P we can find the estimated value of the covariances
Sa = P*Ra*transpose(P);
Sb = P*Rb*transpose(P);

%We can now find the eigenvectors of these estimated covariances
[V,lamb] = eig(Sa,Sa+Sb);

%We have to make sure that the matrix is in descending order with respect
%to the eigenvalues
[~,ind] = sort(diag(lamb),'descend') ;
V = V(:,ind);

%A set of CSP filters is then given
w=transpose(P)*V;

%Take 2*m filters out
w = [w(:,1:m),w(:,end-m+1:end)];
end