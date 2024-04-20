
% Include your classes and scripts
addpath("C:\Users\hh\Desktop\MODEL TRANSLATION MODULES\");
%PARAMETERS INITIALISED FOR SIMULATION
simulationClock = 0; % Initialize simulation clock
maxSimulationTime = 3000; % Duration for the simulation
numServers=3;

commuterTicketPrice = 200;  % Ticket price for commuter
operationalCostCommuter = 1500;  % Operational cost for commuter flight
agentWagePerHour = 35;  % Wage per hour for check-in agent
revenue= 0;  % Initialize profit
ProvincialTicketprice=1500;
operationalCostProvincial=12000;
processedCommuters= 0;
maxCommuterPassengers = 200;
processedProvincials = 0;
maxProvincialPassengers = 200; 
totalWaitTime=0;
totalPassengersServed=0;
serverBusyTimes = zeros(1, numServers);  % Track how long each server is busy
serverAvailable = zeros(1, numServers);  % Track when each server will be available
totalServiceTime = zeros(1, numServers); % Track the total service time for each server
queueLengths = zeros(1, numServers); % Number of passengers in each server's queue
queueEntryTimes = cell(1, numServers); % Times passengers enter each queue


%Estimated parameters after Input Modelling
lambdaCommuter = 39.73 ; 
lambdaProvincialmean=75.19;
lambdaProvincialstdv=6.85;
pCommuter=0.67;
pProvincial=0.83;
servicetimeBoarding=2.13;
servicetimecheckingbags=0.97;
servicetimeproblemsanddelays=2.63;
servicetimescreeningmachine=2.50;

% Initialize totals for Commuter Arrivals
totalArrivalTime = 0;
totalServiceTimePrintingBoardingPass = 0;
totalServiceTimeCheckingBags = 0;
totalServiceTimeProblemsAndDelays = 0;
totalServiceTimeScreening = 0;

%Initialize Totals For Provincial Arrivals
totalProvincialTime=0;
totalProvincialServiceTimePrintBoarding=0;
totalProvincialServiceTimeCheckingBags=0;
totalProvincialServiceTimeProblemsandDelays=0;
totalProvincialServiceTimeScreening=0;


% Initialize Future Event List
FEL = FutureEventList();




