classdef eluLayer < nnet.layer.Layer
    %THIS CLASS WAS WRITTEN ENTIRELY BY
    %https://blogs.mathworks.com/deep-learning/2018/01/05/defining-your-own-network-layer/
    properties (Learnable)
        alpha
    end
    
    methods
        function layer = eluLayer(num_channels,name)
            layer.Type = 'Exponential Linear Unit';
            
            % Assign layer name if it is passed in.
            if nargin > 1
                layer.Name = name;
            end
            
            % Give the layer a meaningful description.
            layer.Description = "Exponential linear unit with " + ...
                num_channels + " channels";
            
            % Initialize the learnable alpha parameter.
            layer.alpha = rand(1,1,num_channels);
        end
        
        function Z = predict(layer,X)
            % Forward input data through the layer at prediction time and
            % output the result
            %
            % Inputs:
            %         layer    -    Layer to forward propagate through
            %         X        -    Input data
            % Output:
            %         Z        -    Output of layer forward function
            
            % Expressing the computation in vectorized form allows it to
            % execute directly on the GPU.
            Z = (X .* (X > 0)) + ...
                (layer.alpha.*(exp(min(X,0)) - 1) .* (X <= 0));
        end
        
        function [dLdX, dLdAlpha] = backward(layer, X, Z, dLdZ, ~)
            % Backward propagate the derivative of the loss function through 
            % the layer
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X                 - Input data
            %         Z                 - Output of layer forward function            
            %         dLdZ              - Gradient propagated from the deeper layer
            %         memory            - Memory value which can be used in
            %                             backward propagation [unused]
            % Output:
            %         dLdX              - Derivative of the loss with
            %                             respect to the input data
            %         dLdAlpha          - Derivatives of the loss with
            %                             respect to alpha
            
            % Original expression:
            % dLdX = (dLdZ .* (X > 0)) + ...
            %     (dLdZ .* (layer + Z) .* (X <= 0));
            %
            % Optimized expression:
            dLdX = dLdZ .* ((X > 0) + ...
                ((layer.alpha + Z) .* (X <= 0)));            
            
            dLdAlpha = exp(min(X,0) - 1) .* dLdZ;
            % Sum over the image rows and columns.
            dLdAlpha = sum(sum(dLdAlpha,1),2);
            % Sum over all the observations in the mini-batch.
            dLdAlpha = sum(dLdAlpha,4);
        end

    end
end