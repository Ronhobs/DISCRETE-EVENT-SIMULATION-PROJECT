% Include your classes and scripts
addpath("C:\Users\hh\Desktop\MODEL TRANSLATION MODULES\");
initializeSimulation;
rng(200);
provincialservers=4;
serverBusyTimes = zeros(1, provincialservers);  % Track how long each server is busy
serverAvailable = zeros(1, provincialservers);  % Track when each server will be available
totalServiceTime = zeros(1, provincialservers); % Track the total service time for each server
queueLengths = zeros(1, provincialservers); % Number of passengers in each server's queue
queueEntryTimes = cell(1, provincialservers); % Times passengers enter each queue

FEL = FutureEventList();
   FEL = FEL.addEvent(Event(normrnd(lambdaProvincialmean, lambdaProvincialstdv), EventType.ProvincialArrivals));  % Schedule the first provincial arrival

% Main simulation loop
 while ~isempty(FEL.list) 
    [nextEvent, FEL] = FEL.getNextEvent();

    if isempty(nextEvent)
        disp('No more events in the FEL.');
        break; % Exit the loop
    else
        % Update simulation clock
        simulationClock = nextEvent.time;
       % Determine which server to assign the passenger to (the one that will be available soonest)
    [minAvailableTime, serverID] = min(serverAvailable);

    if simulationClock >= minAvailableTime
        % Server is available, process the event
        switch nextEvent.type
           case EventType.ProvincialArrivals
                % Increment the provincial passenger counter
                processedProvincials = processedProvincials + 1;
                totalProvincialTime= totalProvincialTime + simulationClock;
                % Find the server (queue) with the shortest line
            [minQueueLength, serverID] = min(queueLengths);
            queueLengths(serverID) = queueLengths(serverID) + 1;
            queueEntryTimes{serverID} = [queueEntryTimes{serverID}, simulationClock]; % Add arrival time to the queue
 % Schedule bags processing for provincial passenger
                FEL = FEL.addEvent(Event(simulationClock, EventType.ProvincialBags));

            case EventType.ProvincialBags
                % Simulate the decision-making process for the number of bags
                numBags = 1; % Commuters carry at least one bag
                while rand() > pProvincial && numBags < 3
                    numBags = numBags + 1; % Add another bag if the commuter decides to bring more
                end
                 % Immediately schedule the ServiceTimeBoardingPass event, passing the number of bags
                FEL = FEL.addEvent(Event(simulationClock, EventType.ServiceTimeBoardingPass));

              case EventType.ServiceTimeBoardingPass
               
                % Calculate the service time for printing a boarding pass
                serviceTimeForPrintingBoardingPass = exprnd(servicetimeBoarding); % Example: Using exponential distribution
                totalProvincialServiceTimePrintBoarding=totalProvincialServiceTimePrintBoarding + serviceTimeForPrintingBoardingPass;
               % Schedule ServiceTimeCheckingBags event after boarding pass is printed
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeForPrintingBoardingPass, EventType.ServiceTimeCheckingBags));
                 % Find the queue this passenger is in (you might need additional logic to track this)
    for serverIdx = 1:provincialservers
        if ~isempty(queueEntryTimes{serverID})
                serviceStartTime = simulationClock; % Marking the service start time
                firstInQueue = queueEntryTimes{serverID}(1); % Get the first passenger's entry time
                waitTime = serviceStartTime - firstInQueue; % Calculate wait time
                totalWaitTime = totalWaitTime + waitTime; % Accumulate total wait time
                 
                % Dequeue the first passenger from the server's queue
                queueEntryTimes{serverID}(1) = [];
                queueLengths(serverID) = queueLengths(serverID) - 1;
                
                % Continue to schedule next event, calculate service times, etc.
        end
    end
            case EventType.ServiceTimeCheckingBags
                % Calculate the service time for checking bags
                serviceTimeForCheckingBags = exprnd(servicetimecheckingbags);
                totalProvincialServiceTimeCheckingBags=totalProvincialServiceTimeCheckingBags + serviceTimeForCheckingBags;

                 % Schedule ServiceTimeProblemsAndDelays event after checking bags
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeForCheckingBags, EventType.ServiceTimeProblemsandDelays));
            
            case EventType.ServiceTimeProblemsandDelays
                % Calculate the time for resolving problems and delays
                serviceTimeProblemsAndDelays = exprnd(servicetimeproblemsanddelays);
                totalProvincialServiceTimeProblemsandDelays= totalProvincialServiceTimeProblemsandDelays + serviceTimeProblemsAndDelays;

                % Schedule ServiceTimeScreening event after resolving problems and delays
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeProblemsAndDelays, EventType.ServiceTimeScreeningMachine));
                
            case EventType.ServiceTimeScreeningMachine
                % Calculate the service time for screening
                serviceTimeScreening = exprnd(servicetimescreeningmachine);
                totalProvincialServiceTimeScreening= totalProvincialServiceTimeScreening + serviceTimeScreening;
               totalPassengersServed = totalPassengersServed + 1;
                 % At this point, we have the total service time for a passenger
                totalServiceTime(serverID) = totalServiceTime(serverID) + serviceTimeForPrintingBoardingPass + serviceTimeForCheckingBags + serviceTimeProblemsAndDelays + serviceTimeScreening;
                serverBusyTimes(serverID) = serverBusyTimes(serverID) + serviceTimeScreening+ serviceTimeForPrintingBoardingPass;  % Only the screening time is added to the busy time
                serverAvailable(serverID) = simulationClock + serviceTimeScreening;  % Server will be available after this time
                % Print a consolidated message for this commuter's complete process
                disp(['Provincial Flight Passenger Arrival Time ', num2str(simulationClock), ', Passenger brought ', num2str(numBags), ' bags. Service time to print boarding pass is ', num2str(serviceTimeForPrintingBoardingPass), '.' ...
                    'Service time to check bags is ', num2str(serviceTimeForCheckingBags), ' minutes.''Time to resolve problems and delays is ', num2str(serviceTimeProblemsAndDelays), ' minutes.' ...
                    'Service time for screening is ', num2str(serviceTimeScreening), ' minutes.']);

               % Schedule the next provincial passenger's arrival
                if processedProvincials < maxProvincialPassengers
                    nextArrivalTime = simulationClock + normrnd(lambdaProvincialmean, lambdaProvincialstdv);
                    if nextArrivalTime <= maxSimulationTime
                        FEL = FEL.addEvent(Event(nextArrivalTime, EventType.ProvincialArrivals));
                    else
                        disp('Reached max simulation time, no more provincial arrivals will be scheduled.');
                    end
                end
        end
    end
    end
 end
     %Calculate the average waiting time if any passengers were served
if processedProvincials > 0
    averageWaitTime = totalWaitTime / simulationClock;
    disp(['Average waiting time: ', num2str(averageWaitTime), ' minutes.']);
else
    disp('No passengers were processed.');
end
% Calculate the average utilization and other output parameters
averageUtilization = mean(totalServiceTime) / ( simulationClock *provincialservers);

% Calculate the average total service time across all servers
averageTotalServiceTime = mean(totalServiceTime);
% Calculate the total cost considering operational costs and agent wages
totalCost = operationalCostProvincial + agentWagePerHour * provincialservers * (simulationClock / 60);
%Calculate revenue
revenue = revenue+( ProvincialTicketprice*maxProvincialPassengers) - (operationalCostProvincial);
profit=revenue-totalCost;
% Calculate agent idle times
totalIdleTime = simulationClock  - sum(serverBusyTimes);
averageIdleTime = totalIdleTime / simulationClock;
% Output the simulation results
disp(['Simulation Time: ', num2str(maxSimulationTime), 'minutes']);
disp(['Total Utilization: ', num2str(averageUtilization * 100), ]);
disp(['Average total service time across all servers: ', num2str(averageTotalServiceTime), 'minutes']);
disp(['Total revenue from commuter Flight: ', '$',num2str(revenue), ]);
disp(['Total cost: ', '$', num2str(totalCost)]);
disp(['Total Profit from commuter Flight: ', '$',num2str(profit)]);
disp(['Average idle time per agent: ', num2str(averageIdleTime), 'minutes']);


% After processing all commuters (e.g., at the end of the loop or script)
% Calculate averages
averageProvincialArrivalTime = totalProvincialTime / maxProvincialPassengers;
averageProvincialServiceTimePrintingBoardingPass = totalProvincialServiceTimePrintBoarding / processedProvincials;
averageProvincialServiceTimeCheckingBags = totalProvincialServiceTimeCheckingBags / processedProvincials;
averageProvincialServiceTimeProblemsAndDelays = totalProvincialServiceTimeProblemsandDelays / processedProvincials;
averageProvincialServiceTimeScreening = totalProvincialServiceTimeScreening/ processedProvincials;

disp(['Average Provincial Arrival Time: ', num2str(averageProvincialArrivalTime), ' minutes.']);
disp(['Average Time to Print Boarding Pass for Provincial Passengers: ', num2str(averageProvincialServiceTimePrintingBoardingPass), ' minutes.']);
disp(['Average Time to Check Bags for Provincial Passengers: ', num2str(averageProvincialServiceTimeCheckingBags), ' minutes.']);
disp(['Average Time for Problems and Delays for Provincial Passengers: ', num2str(averageProvincialServiceTimeProblemsAndDelays), ' minutes.']);
disp(['Average Time for Screening for Provincial Passengers: ', num2str(averageProvincialServiceTimeScreening), ' minutes.']);

% Open a file for writing
fileID = fopen('provincial_results.txt', 'w');

% Check if file was opened successfully
if fileID == -1
    disp('Error opening file.');
else
    % Write simulation results to the file
    
    fprintf(fileID, 'Simulation Time: %d minutes\n', maxSimulationTime);
    fprintf(fileID, 'Total Utilization: %.2f%%\n', averageUtilization * 100);
    fprintf(fileID, 'Average total service time across all servers: %.2f minutes\n', averageTotalServiceTime);
    fprintf(fileID, 'Total revenue from commuter Flight: $%.2f\n', revenue);
    fprintf(fileID, 'Total cost: $%.2f\n', totalCost);
    fprintf(fileID, 'Total Profit from commuter Flight: $%.2f\n', profit);
    fprintf(fileID, 'Average idle time per agent: %.2f minutes\n', averageIdleTime);
    
    % Close the file
    fclose(fileID);
    
    % Display message indicating success
    disp('Results have been written to commuter_results.txt');
end


