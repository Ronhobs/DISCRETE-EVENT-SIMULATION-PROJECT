function [averageWaitTime, averageUtilization, averageIdleTime, averageServiceTime, averageArrivalTime,averageServiceTimePrintingBoardingPass,averageServiceTimeCheckingBags,averageServiceTimeProblemsAndDelays ,averageServiceTimeScreening,revenue, totalCost, profit] = runSimulation(simulationClock, maxSimulationTime, numServers, ~, commuterTicketPrice, operationalCostCommuter, agentWagePerHour, ~, lambdaCommuter, ~, ~, pCommuter, ~, servicetimeBoarding, servicetimecheckingbags, servicetimeproblemsanddelays, servicetimescreeningmachine, ~, maxCommuterPassengers, ~, ~, ~)

    % Initialize state variables
  
    serverBusyTimes = zeros(1, numServers);
    serverAvailable = zeros(1, numServers);
    totalServiceTime = zeros(1, numServers);
    queueLengths = zeros(1, numServers);
    queueEntryTimes = cell(1, numServers);
    totalWaitTime = 0;
    processedCommuters = 0;
    totalPassengersServed = 0;
    totalArrivalTime = 0;
totalServiceTimePrintingBoardingPass = 0;
totalServiceTimeCheckingBags = 0;
totalServiceTimeProblemsAndDelays = 0;
totalServiceTimeScreening = 0;
    FEL = FutureEventList();

    % Generate initial passenger arrival events for all passengers
for i = 1:maxCommuterPassengers
    interArrivalTime = exprnd(60 / lambdaCommuter); % Adjust lambdaCommuter accordingly
    FEL = FEL.addEvent(Event(i * interArrivalTime, EventType.CommuterArrivals));
end


% Main simulation loop
while ~isempty(FEL.list) && maxCommuterPassengers < maxSimulationTime
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
            case EventType.CommuterArrivals
                % Increment the passenger counter
                processedCommuters = processedCommuters + 1;
                totalArrivalTime = totalArrivalTime + simulationClock; 
              % Find the server (queue) with the shortest line
            [~, serverID] = min(queueLengths);
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
                % Example: Using exponential distribution
               % Schedule ServiceTimeCheckingBags event after boarding pass is printed
                FEL = FEL.addEvent(Event(simulationClock + serviceTimeForPrintingBoardingPass, EventType.ServiceTimeCheckingBags));
                 % Find the queue this passenger is in (you might need additional logic to track this)
    for serverIdx = 1:numServers
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
                serverBusyTimes(serverID) = serverBusyTimes(serverID) + servicetimescreeningmachine+ servicetimecheckingbags+ serviceTimeForPrintingBoardingPass;  % Only the screening time is added to the busy time
                serverAvailable(serverID) = simulationClock + serviceTimeScreening;  % Server will be available after this time

                % Print a consolidated message for this commuter's complete process
                disp(['Commuter Coach Passenger Arrival Time is ', num2str(simulationClock), ', Passenger brought ', num2str(numBags), ' bags. Service time to print boarding pass is ', num2str(serviceTimeForPrintingBoardingPass), '.' ...
                    'Service time to check bags is ', num2str(serviceTimeForCheckingBags), ' minutes.''Time to resolve problems and delays is ', num2str(serviceTimeProblemsAndDelays), ' minutes.' ...
                    'Service time for screening is ', num2str(serviceTimeScreening), ' minutes.']);

                
                % Schedule the next commuter arrival if we haven't reached the max passengers
                if processedCommuters < maxCommuterPassengers
                    interArrivalTime = exprnd(1/lambdaCommuter); % Exponential distribution
                    nextArrivalTime = simulationClock + interArrivalTime;
                    
                    % Ensure next arrival is within simulation timeframe
                    if nextArrivalTime <= maxSimulationTime
                        FEL = FEL.addEvent(Event(nextArrivalTime, EventType.CommuterArrivals));
                   
                    end
                end
        end
    end
    end
    % Update total simulation time
 
end
    averageWaitTime = totalWaitTime / processedCommuters;
  

% Calculate the average total service time across all servers
averageServiceTime = mean(totalServiceTime);
% Calculate the average utilization and other output parameters
averageUtilization = sum(serverBusyTimes) / maxSimulationTime* numServers;

% Calculate the total cost considering operational costs and agent wages
totalCost = operationalCostCommuter + agentWagePerHour * numServers * (simulationClock / 60);
%Calculate revenue
revenue = ( commuterTicketPrice*maxCommuterPassengers) - (operationalCostCommuter);
profit=revenue-totalCost;
% Correcting Average Idle Time Calculation
% Average Idle Time = (Total simulation time * Number of servers - Sum of all servers' busy times) / Number of servers
averageIdleTime = ((simulationClock * numServers) - sum(serverBusyTimes)) / simulationClock;

averageArrivalTime = totalArrivalTime / maxCommuterPassengers;
averageServiceTimePrintingBoardingPass = totalServiceTimePrintingBoardingPass / processedCommuters;
averageServiceTimeCheckingBags = totalServiceTimeCheckingBags / processedCommuters;
averageServiceTimeProblemsAndDelays = totalServiceTimeProblemsAndDelays / processedCommuters;
averageServiceTimeScreening = totalServiceTimeScreening / processedCommuters;


end