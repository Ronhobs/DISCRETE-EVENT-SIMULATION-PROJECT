%Defines a class for the future event list for the Aiport Simulation

classdef FutureEventList
    properties
        list      % Collection of events
        listSize  % Number of events in the FEL
    end
    methods
    
        % Constructor
        function obj = FutureEventList(firstEvent)
            if nargin > 0 % Ensures that firstEvent is provided
                obj.listSize = 1;
                obj.list = firstEvent; % Initializes the list with the first event
            else
                obj.listSize = 0;
                obj.list = [];
            end
        end
        
        % Adds newEvent into list in correct chronological position
        function obj = addEvent(obj, newEvent)
            added = false;
            
            % Iterate through the list to find the correct position for newEvent
            for i = 1:obj.listSize
                if obj.list(i).time > newEvent.time
                    obj.list = [obj.list(1:(i-1)), newEvent, obj.list(i:end)];
                    added = true;
                    break; % Exit the loop once the event is added
                end
            end
            
            % If the event is not added in the loop, append it at the end
            if ~added
                obj.list = [obj.list, newEvent];
            end
            
            % Increment the list size
            obj.listSize = obj.listSize + 1;
        end
        
        % Returns and removes the event at the front of the FEL
        function [nextEvent, obj] = getNextEvent(obj)
            if obj.listSize > 0
                nextEvent = obj.list(1); % Get the next event
                obj.list(1) = []; % Remove the event from the list
                obj.listSize = obj.listSize - 1; % Decrement the list size
            else
                nextEvent = []; % If the list is empty, return an empty array
            end
        end
        
        % Other methods remain unchanged
    end
end
           
              
