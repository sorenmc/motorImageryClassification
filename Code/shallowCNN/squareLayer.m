classdef squareLayer < nnet.layer.Layer

    properties
        % (Optional) Layer properties

        % Layer properties go here
    end

    properties (Learnable)
        % (Optional) Layer learnable parameters

        % Layer learnable parameters go here
    end
    
    methods
        function layer = squareLayer()
            % (Optional) Create a myLayer
            % This function must have the same name as the layer
            layer.Type = 'Square Layer Unit';
            
            % Layer constructor function goes here
            if nargin>1
                layer.Name = name;
            end
            
            layer.Description = "Square nonlinear unit layer";
            
            
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
            Z = X.^2;
            %Z(isnan(Z)) = 0
            
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
            dLdX = dLdZ;
            %dLdX = 2.*Z;
            
            
        end
    end
end

