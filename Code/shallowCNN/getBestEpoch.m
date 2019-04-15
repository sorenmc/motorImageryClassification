function [net] = getBestEpoch(info)

    bestIter = info.bestIteration;
    bestIte = int2str(bestIter-mod(bestIter,10));
    files = dir('*.mat');
    
    if(exist('temp.mat','file'))
        delete('temp.mat')
        files = dir('*.mat');
    end
    
    for k = 1:length(files)
        currentFile = files(k).name;
        if(strcmp(currentFile(21:21+length(bestIte)-1),bestIte))
            break;
        end
    end
    
    net = load(currentFile);
    net = net.net;



for k = 1:length(files)
    currentFile = files(k).name;
    delete(currentFile);
end
    
end