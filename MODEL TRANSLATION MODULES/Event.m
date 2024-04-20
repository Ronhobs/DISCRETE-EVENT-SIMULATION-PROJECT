
% THIS SOURCE CODE DEFINES A CLASS FOR EACH EVENT IN THE FUTURE EVENT LIST 
%AN EVENT CONSISTS OF THE TIME THE EVENT OCCURS AND THE TYPE OF EVENT
classdef Event
    properties
        %TIME EVENT OCCURS
        time
        %TYPE OF EVENT
        type
    end
    methods
        %EVENT CONSTRUCTOR
        function obj = Event(eventTime, eventType)
            obj.time = eventTime;
            obj.type = eventType;
        end 
        %PRINTS EVENT
        function printEvent(self)
            fprintf("(%f, %s)", self.time, self.type);
        end
    end
end