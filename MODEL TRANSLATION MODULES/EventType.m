%Defines an enumeration of all valid event types for the simulation.
%These are:
%Commuterarrivals: The arrival time of commuter passengers which follows
%poisson process

%Provincialarrivals: The arrival time of provincial passengers which
%follows normal distribution

%Commuterbags:The chance a customer stops bringing bags follows a Geometric
%distribution

%Provincialbags: The chance a customer stops bringing bags follows a
%Geometric distribution


%ServiceTimeBoardingPass: service time to print boarding pass follows an
%exponential distribution

%ServiceTimeCheckingBags: service time to check bags follows an exponential
%distribution

%ServiceTimeProblemsandDelays: service time for problems and delays follows
%an exponential distribution

%ServiceTimeScreeningMachine: service time for each screening machine
%follows an exponential distribution

classdef EventType
    enumeration
       CommuterArrivals, ProvincialArrivals, CounterAvailable, CommuterBags, ProvincialBags, 
       ServiceTimeBoardingPass, ServiceTimeCheckingBags,
       ServiceTimeProblemsandDelays, ServiceTimeScreeningMachine,
       endOfSimulation
    end
end
