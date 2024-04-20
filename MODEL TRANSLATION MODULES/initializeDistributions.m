%creates the 8 distribution functions with parameters determined through 
%input modelling in deliverable 1
function [CommuterArrivals, ProvincialArrivals, CommuterBags, ProvincialBags, ...
    ServiceTimeBoardingPass, ServiceTimeCheckingBags, ServiceTimeProblemsandDelays, ...
    ServiceTimeScreeningMachine] = initializeDistributions()
    % Initialize the distributions based on specified parameters

    CommuterArrivals = makedist('Poisson', 'mu', 39.73);
    ProvincialArrivals = makedist('Normal', 'mu', 'sigma',75.19,6.85);
    CommuterBags = makedist('Geometric', 'p', 0.67); % Assuming 'mu' refers to the mean, which in Geometric distribution is 1/p
    ProvincialBags = makedist('Geometric', 'p', 0.83); % Adjusting 'mu' to 'p' for Geometric distribution
    ServiceTimeBoardingPass = makedist('Exponential', 'mu', 2.13);
    ServiceTimeCheckingBags = makedist('Exponential', 'mu', 0.97);
    ServiceTimeProblemsandDelays = makedist('Exponential', 'mu', 2.63); % Assuming this is a different parameter, adjusted accordingly
    ServiceTimeScreeningMachine = makedist('Exponential', 'mu', 2.50); % Assuming another parameter, adjust as needed
end
