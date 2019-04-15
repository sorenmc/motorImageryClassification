function stop = checkIfOverfittingCopy(info)

stop = false;
info.OverFitting = false;
info.UnderFitting = false;
info.NoChange = false;

% Keep track of the best validation accuracy and the number of validations for which
% there has not been an improvement of the accuracy.
%persistent N
%persistent M
persistent bestValAccuracy
persistent bestIteration
% Clear the variables when training starts.
if info.State == "start"
    %N = 0;
    %M = 0;
    bestValAccuracy = 0;
    bestIteration = 0;
    % Checks if validation has been made
elseif ~isempty(info.ValidationLoss)
        % Checking if there is no improvement
        if info.ValidationAccuracy >= bestValAccuracy
            bestValAccuracy = info.ValidationAccuracy;
            bestIteration = info.Iteration;          
        end
            
end

if info.State == "done"
    info.bestIteration = bestIteration;
    save('temp.mat','info');
end

end