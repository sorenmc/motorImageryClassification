classdef permuteLayer < nnet.layer.Layer

% Creates a layer that permutes the 3rd dimension to the first
% Created using the template from
% https://blogs.mathworks.com/deep-learning/2018/01/05/defining-your-own-network-layer/
%
% AUTHORS OF FUNCTION:
% Soeren Moeller Christensen, s153571@student.dtu.dk
% Nicklas Stubkjaer Holm, s154411@student.dtu.dk

    properties
        % Layer properties go here
    end
    
    properties (Learnable)
        % (Optional) Layer learnable parameters
        % Layer learnable parameters go here
    end
    
    methods
        function layer = permuteLayer()
            % (Optional) Create a myLayer
            % This function must have the same name as the layer
            layer.Type = 'Permute Layer';
            
            % Layer constructor function goes here
            if nargin>1
                layer.Name = name;
            end
            
            layer.Description = "permute";
            
            
        end
        
        function Z = predict(layer, X)
            % Forward input data through the layer at prediction time and
            % output the result
            %
            % Inputs:
            %         layer    -    Layer to forward propagate through
            %         X        -    Input data
            % Output:
            %         Z        -    Output of layer forward function
            
            % Layer forward function for prediction goes here
            if(length(size(X)) < 4)
                Z = permute(X,[3,2,1]);
            else
                Z = permute(X,[3,2,1,4]);
            end
        end
        
        
        
        function [dLdX] = backward(layer, X, Z, dLdZ,~)
            % Backward propagate the derivative of the loss function through
            % the layer
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X                 - Input data
            %         Z                 - Output of layer forward function
            %         dLdZ              - Gradient propagated from the deeper layer
            %         memory            - Memory value which can be used in
            %                             backward propagation
            % Output:
            %         dLdX              - Derivative of the loss with respect to the
            %                             input data
            %         dLdW1, ..., dLdWn - Derivatives of the loss with respect to each
            %                             learnable parameter
            
            % Layer backward function goes here
            
            
            if(length(size(dLdZ)) < 4)
                dLdX = permute(dLdZ,[3,2,1]);
                
            else
                dLdX = permute(dLdZ,[3,2,1,4]);
            end  
        end
    end
end

