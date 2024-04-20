% Include your classes and scripts
addpath("C:\Users\hh\Desktop\MODEL TRANSLATION MODULES\");
initializeSimulation;
rng(200);
serverBusyTimes = zeros(1, numServers);  % when a server is busy
serverAvailable = zeros(1, numServers);  % Server availability
totalServiceTime = zeros(1, numServers); % Keeps track of the total service time for a passenger
queueLengths = zeros(1, numServers); % The length of a passenger in each queue
queueEntryTimes = cell(1, numServers); % Time passenger enters a queue


FEL = FutureEventList();
%  Initialise commuter passenger arrival events for all passengers
for i = 1:maxCommuterPassengers
    interArrivalTime = exprnd(60/ lambdaCommuter); 
    FEL = FEL.addEvent(Event(i * interArrivalTime, EventType.CommuterArrivals));
    
end

  % Main simulation loop

while ~isempty(FEL.list) 
    [nextEvent, FEL] = FEL.getNextEvent();

    if isempty(nextEvent)
        disp('There are no more events in the Future Event List.');
        
        break; % Exit loop
    else

        % Simulation Clock Updated
        simulationClock = nextEvent.time;
         %Assign a passenger to the server available
    [minAvailableTime, serverID] = min(serverAvailable);

    if simulationClock >= minAvailableTime
        % Server is available, process the event

        switch nextEvent.type
            case EventType.CommuterArrivals
                % Increment the processed commuters
                processedCommuters = processedCommuters + 1;
                totalArrivalTime = totalArrivalTime + simulationClock; 
              % Find the server (queue) with the shortest line
            [minQueueLength, serverID] = min(queueLengths);
            queueLengths(serverID) = queueLengths(serverID) + 1;
            queueEntryTimes{serverID} = [queueEntryTimes{serverID}, simulationClock]; % Add arrival time to the queue

                % Immediately schedule the CommuterBags event
                FEL = FEL.addEvent(Event(simulationClock, EventType.CommuterBags));

            case EventType.CommuterBags
                % Simulate the decision-making process for the number of bags
                numBags = 1; % Commuters carry at least one bag
                while rand() > pCommuter && numBags < 3
                    numBags = numBags + 1; % Add another bag if the commuter decides to bring more
                end
               
                 % Immediately schedule the ServiceTimeBoardingPass event, passing the number of bags
                FEL = FEL.addEvent(Event(simulationClock, EventType.ServiceTimeBoardingPass));

              case EventType.ServiceTimeBoardingPass
               
                % Calculate the service time for printing a boarding pass
                serviceTimeForPrintingBoardingPass = exprnd(servicetimeBoarding); 
                totalServiceTimePrintingBoardingPass = totalServiceTimePrintingBoardingPass + serviceTimeForPrintingBoardingPass;
               
               % Schedule ServiceTimeCheckingBags event after boarding pass is printed
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeForPrintingBoardingPass, EventType.ServiceTimeCheckingBags));
                 % Find the queue this passenger is in 
    for serverIdx = 1:numServers
        if ~isempty(queueEntryTimes{serverID})
                serviceStartTime = simulationClock; % Marking the service start time
                firstInQueue = queueEntryTimes{serverID}(1); % Get the first passenger's entry time
                waitTime = serviceStartTime - firstInQueue; % Calculate wait time
                totalWaitTime = totalWaitTime + waitTime; % Accumulate total wait time
                 
                % Dequeue the first passenger from the server's queue
                queueEntryTimes{serverID}(1) = [];
                queueLengths(serverID) = queueLengths(serverID) - 1;
                
        end
    end
            
            case EventType.ServiceTimeCheckingBags
                % Calculate the service time for checking bags
                serviceTimeForCheckingBags = exprnd(servicetimecheckingbags);
                totalServiceTimeCheckingBags=totalServiceTimeCheckingBags+serviceTimeForCheckingBags;

                 % Schedule ServiceTimeProblemsAndDelays event after checking bags
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeForCheckingBags, EventType.ServiceTimeProblemsandDelays));
            
            case EventType.ServiceTimeProblemsandDelays
                % Calculate the time for resolving problems and delays
                serviceTimeProblemsAndDelays = exprnd(servicetimeproblemsanddelays);
                totalServiceTimeProblemsAndDelays=totalServiceTimeProblemsAndDelays+serviceTimeProblemsAndDelays;
                % Schedule ServiceTimeScreening event after resolving problems and delays
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeProblemsAndDelays, EventType.ServiceTimeScreeningMachine));
              
            case EventType.ServiceTimeScreeningMachine
                % Calculate the service time for screening
                serviceTimeScreening = exprnd(servicetimescreeningmachine);
                totalPassengersServed = totalPassengersServed + 1;
                totalServiceTimeScreening=totalServiceTimeScreening+ serviceTimeScreening;
                 % At this point, we have the total service time for a passenger
                totalServiceTime(serverID) = totalServiceTime(serverID) + serviceTimeForPrintingBoardingPass + serviceTimeForCheckingBags + serviceTimeProblemsAndDelays + serviceTimeScreening;
                serverBusyTimes(serverID) = serverBusyTimes(serverID) + servicetimescreeningmachine+ servicetimecheckingbags+ serviceTimeForPrintingBoardingPass;  
                serverAvailable(serverID) = simulationClock + serviceTimeScreening;  % Server will be available after this time

                % Print a consolidated message for this commuter's complete process
                disp(['Commuter Coach Passenger Arrival Time is ', num2str(simulationClock), ', Passenger brought ', num2str(numBags), ' bags. Service time to print boarding pass is ', num2str(serviceTimeForPrintingBoardingPass), '.' ...
                    'Service time to check bags is ', num2str(serviceTimeForCheckingBags), ' minutes.''Time to resolve problems and delays is ', num2str(serviceTimeProblemsAndDelays), ' minutes.' ...
                    'Service time for screening is ', num2str(serviceTimeScreening), ' minutes.']);

                
              
        end
    end
    end
    % Update total simulation time
 
end
disp(['Final FEL size: ', num2str(FEL.listSize)]);

% Calculate the average waiting time if any passengers were served
if processedCommuters > 0
    averageWaitTime = totalWaitTime / processedCommuters;
    disp(['Average waiting time: ', num2str(averageWaitTime), ' minutes.']);

end

%The mean service time across all three servers
averageTotalServiceTime = mean(totalServiceTime);
% Calculate the average utilization and other output parameters
averageUtilization = mean(totalServiceTime) / simulationClock * numServers ;

% Calculate the total cost considering operational costs and agent wages
totalCost = operationalCostCommuter + (agentWagePerHour* numServers) * (simulationClock / 60);
%Calculate revenue
revenue = revenue+( commuterTicketPrice*maxCommuterPassengers) - (operationalCostCommuter);
profit=revenue-totalCost;
% Correcting Average Idle Time Calculation
% Average Idle Time = (Total simulation time * Number of servers - Sum of all servers' busy times) / Number of servers
averageIdleTime = ((simulationClock * numServers) - sum(serverBusyTimes)) / simulationClock;

% Assuming the variables (maxSimulationTime, averageUtilization, averageTotalServiceTime, revenue, totalCost, profit, averageIdleTime, totalArrivalTime, maxCommuterPassengers, processedCommuters, totalServiceTimePrintingBoardingPass, totalServiceTimeCheckingBags, totalServiceTimeProblemsAndDelays, totalServiceTimeScreening) are already calculated in your script

% Compile simulation results into a struct
simulationResults = struct(...
    'SimulationTime', maxSimulationTime, ...
    'TotalUtilization', averageUtilization * 100, ...
    'AverageServiceTime', averageTotalServiceTime, ...
    'Revenue', revenue, ...
    'TotalCost', totalCost, ...
    'Profit', profit, ...
    'AverageIdleTime', averageIdleTime, ...
    'AverageArrivalTime', totalArrivalTime / maxCommuterPassengers, ...
    'AverageTimePrintingBoardingPass', totalServiceTimePrintingBoardingPass / processedCommuters, ...
    'AverageTimeCheckingBags', totalServiceTimeCheckingBags / processedCommuters, ...
    'AverageTimeProblemsAndDelays', totalServiceTimeProblemsAndDelays / processedCommuters, ...
    'AverageTimeScreening', totalServiceTimeScreening / processedCommuters ...
);


% Print report to MATLAB console
printSimulationReport(simulationResults, 1);

% Write report to a file
fileID = fopen('SimulationReport.txt', 'w');
if fileID ~= -1
    try
        printSimulationReport(simulationResults, fileID);
    catch exception
        fprintf(1, 'Error writing to file: %s\n', exception.message);
    end
    fclose(fileID);
else
    fprintf(1, 'Failed to open file for writing.\n');
end


% Function to print and write simulation report
function printSimulationReport(simulationResults, fileID)
    fprintf(fileID, '--- Simulation Report ---\n\n');
    fprintf(fileID, 'Simulation Time: %d minutes\n', simulationResults.SimulationTime);
    fprintf(fileID, 'Total Utilization: %.2f%%\n', simulationResults.TotalUtilization);
    fprintf(fileID, 'Average Total Service Time Across All Servers: %.2f minutes\n', simulationResults.AverageServiceTime);
    fprintf(fileID, 'Revenue from Commuter Flight: $%.2f\n', simulationResults.Revenue);
    fprintf(fileID, 'Total Cost: $%.2f\n', simulationResults.TotalCost);
    fprintf(fileID, 'Profit from Commuter Flight: $%.2f\n', simulationResults.Profit);
    fprintf(fileID, 'Average Idle Time Per Agent: %.2f minutes\n', simulationResults.AverageIdleTime);
    fprintf(fileID, '\nDetailed Service Times:\n');
    fprintf(fileID, 'Average Arrival Time: %.2f minutes\n', simulationResults.AverageArrivalTime);
    fprintf(fileID, 'Average Time to Print Boarding Pass: %.2f minutes\n', simulationResults.AverageTimePrintingBoardingPass);
    fprintf(fileID, 'Average Time to Check Bags: %.2f minutes\n', simulationResults.AverageTimeCheckingBags);
    fprintf(fileID, 'Average Time for Problems and Delays: %.2f minutes\n', simulationResults.AverageTimeProblemsAndDelays);
    fprintf(fileID, 'Average Time for Screening: %.2f minutes\n', simulationResults.AverageTimeScreening);
end



