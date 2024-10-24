
% Include your classes and scripts
addpath("C:\Users\hh\Desktop\MODEL TRANSLATION MODULES\");
numReplications = 210;
 initializeSimulation;
provincialservers=4;
rng(4000);
% Arrays to store individual results from each replication
waitTimesArray = zeros(1, numReplications);
utilizationsArray = zeros(1, numReplications);
idleTimesArray = zeros(1, numReplications);
revenuesArray = zeros(1, numReplications);
costsArray = zeros(1, numReplications);
profitsArray = zeros(1, numReplications);
servicetimeBoardingArray = zeros(1, numReplications);
servicetimeCheckingBagsArray = zeros(1, numReplications);
servicetimeProblemsArray = zeros(1, numReplications);
servicetimeScreeningArray = zeros(1, numReplications);



% Loop to perform multiple replications
for replication = 1:numReplications
 
   % Call a function to run the simulation which contains your while loop
    % and returns the necessary statistics
[averageWaitTime, averageUtilization, averageIdleTime, averageTotalServiceTime, averageProvincialArrivalTime,averageProvincialServiceTimePrintingBoardingPass,averageProvincialServiceTimeCheckingBags,averageProvincialServiceTimeProblemsAndDelays ,averageProvincialServiceTimeScreening,revenue, totalCost, profit] = provincialrunsimulation(simulationClock, maxSimulationTime, provincialservers, totalPassengersServed, commuterTicketPrice, operationalCostCommuter, agentWagePerHour, revenue, lambdaCommuter, lambdaProvincialmean, lambdaProvincialstdv, pCommuter, pProvincial, servicetimeBoarding, servicetimecheckingbags, servicetimeproblemsanddelays, servicetimescreeningmachine, processedCommuters, maxCommuterPassengers, processedProvincials, maxProvincialPassengers, FEL);
    % After each replication, update the aggregated statistics
   % Inside your replication loop
waitTimesArray(replication) = averageWaitTime;
utilizationsArray(replication) = averageUtilization;
idleTimesArray(replication) = averageIdleTime;
revenuesArray(replication) = revenue;
costsArray(replication) = totalCost;
profitsArray(replication) = profit;

servicetimeBoardingArray(replication) = averageServiceTimePrintingBoardingPass;
servicetimeCheckingBagsArray(replication) = averageServiceTimeCheckingBags;
servicetimeProblemsArray(replication) = averageServiceTimeProblemsAndDelays;
servicetimeScreeningArray(replication) = averageServiceTimeScreening;


maxprovincialpassengers = 200; 
end
%Calculate mean and variance after certain numnber of replications
meanWaitTime=mean(waitTimesArray);
meanUtilization=mean(utilizationsArray);
meanIdleTime=mean(idleTimesArray);
meanRevenue=mean(revenuesArray);
meanCost=mean(costsArray);
meanProfits=mean(profitsArray);

meanServiceTimePrintingBoardingPass=mean(servicetimeBoardingArray);
meanServiceTimeCheckingBags=mean(servicetimeCheckingBagsArray);
meanServiceTimeProblems=mean(servicetimeProblemsArray);
meanServiceTimeScreening=mean(servicetimeScreeningArray);

varWaitTime=var(waitTimesArray);
varUtilization=var(utilizationsArray);
varIdleTime=var(idleTimesArray);
varRevenue=var(revenuesArray);
varCost=var(costsArray);
varProfits=var(profitsArray);

varServiceTimePrintingBoardingPass=var(servicetimeBoardingArray);
varServiceTimeCheckingBags=var(servicetimeCheckingBagsArray);
varServiceTimeProblems=var(servicetimeProblemsArray);
varServiceTimeScreening=var(servicetimeScreeningArray);

% Repeat calculations for other metrics
fprintf('Average Wait Time: %.4f minutes\n', meanWaitTime);
fprintf('Variance of Wait Time: %.4f\n', varWaitTime);

fprintf('Average Utilization: %.4f %\n', meanUtilization *100);
fprintf('Variance of Utilization: %.4f\n', varUtilization);

fprintf('Average Idle Time: %.4f minutes\n', meanIdleTime);
fprintf('Variance of Idle Time: %.4f\n', varIdleTime);

fprintf('Average Revenue: %.4f dollars\n', meanRevenue);
fprintf('Variance of Revenue: %.4f\n', varRevenue);

fprintf('Average Cost: %.4f dollars\n', meanCost);
fprintf('Variance of Cost: %.4f\n', varCost);

fprintf('Average Profits: %.4f minutes\n', meanProfits);
fprintf('Variance of Profits: %.4f\n', varProfits);

fprintf('Average Service Time: %.4f minutes\n', meanServiceTime);
fprintf('Variance of Service Time: %.4f\n', varServiceTime);

fprintf('Average Service Time to Print Boarding Pass: %.4f minutes\n', meanServiceTimePrintingBoardingPass);
fprintf('Variance of Service Time to Print Boarding Pass : %.4f\n', varServiceTimePrintingBoardingPass);

fprintf('Average Service Time to Check Bags: %.4f minutes\n', meanServiceTimeCheckingBags);
fprintf('Variance of Service Time to Check Bags: %.4f\n', varServiceTimeCheckingBags);

fprintf('Average Service Time Incase of Problems: %.4f minutes\n', meanServiceTimeProblems);
fprintf('Variance of Service Time Incase of Problems and Delays: %.4f\n', varServiceTimeProblems);

fprintf('Average Service Time for Screening: %.4f minutes\n', meanServiceTimeScreening);
fprintf('Variance of Service Time for Screening: %.4f\n', varServiceTimeScreening);

%We will use to calculate confidence interval for other metrics
alpha = 0.05; % For 95% confidence
df = numReplications - 1; % Degrees of freedom

% Confidence interval for wait times
ciHalfWidthWaitTime = tinv(1-alpha/2, df) * sqrt(varWaitTime / numReplications);
ciWaitTime = [meanWaitTime - ciHalfWidthWaitTime, meanWaitTime + ciHalfWidthWaitTime];

fprintf('95%% Confidence Interval for Wait Time: [%.4f, %.4f]\n', ciWaitTime(1), ciWaitTime(2));


% Confidence interval for wait times
ciHalfWidthUtilization = tinv(1-alpha/2, df) * sqrt(varUtilization / numReplications);
ciUtilization = [meanUtilization - ciHalfWidthUtilization, meanUtilization + ciHalfWidthUtilization];

fprintf('95%% Confidence Interval for Utilization: [%.4f, %.4f]\n', ciUtilization(1), ciUtilization(2));


% Confidence interval for wait times
ciHalfWidthIdleTime = tinv(1-alpha/2, df) * sqrt(varIdleTime / numReplications);
ciIdleTime = [meanIdleTime - ciHalfWidthIdleTime, meanIdleTime + ciHalfWidthIdleTime];

fprintf('95%% Confidence Interval for Idle Time: [%.4f, %.4f]\n', ciIdleTime(1), ciIdleTime(2));


% Confidence interval for wait times
ciHalfWidthRevenue = tinv(1-alpha/2, df) * sqrt(varRevenue / numReplications);
ciRevenue= [meanRevenue - ciHalfWidthRevenue, meanRevenue + ciHalfWidthRevenue];

fprintf('95%% Confidence Interval for Revenue: [%.4f, %.4f]\n', ciRevenue(1), ciRevenue(2));


% Confidence interval for wait times
ciHalfWidthCost = tinv(1-alpha/2, df) * sqrt(varCost / numReplications);
ciCost = [meanCost - ciHalfWidthCost, meanCost + ciHalfWidthCost];

fprintf('95%% Confidence Interval for Cost: [%.4f, %.4f]\n', ciCost(1), ciCost(2));

% Confidence interval 
ciHalfWidthProfits = tinv(1-alpha/2, df) * sqrt(varProfits / numReplications);
ciProfits = [meanProfits - ciHalfWidthProfits, meanProfits + ciHalfWidthProfits];

fprintf('95%% Confidence Interval for Profits: [%.4f, %.4f]\n', ciProfits(1), ciProfits(2));

% Confidence interval 
ciHalfWidthServiceTimePrintingBoardingPass = tinv(1-alpha/2, df) * sqrt(varServiceTimePrintingBoardingPass / numReplications);
ciServiceTimePrintingBoardingPass = [meanServiceTimePrintingBoardingPass - ciHalfWidthServiceTimePrintingBoardingPass, meanServiceTimePrintingBoardingPass + ciHalfWidthServiceTimePrintingBoardingPass];

fprintf('95%% Confidence Interval for Service Time to Printing Boarding Pass: [%.4f, %.4f]\n', ciServiceTimePrintingBoardingPass(1), ciServiceTimePrintingBoardingPass(2));

% Confidence interval for wait times
ciHalfWidthServiceTimeCheckingBags = tinv(1-alpha/2, df) * sqrt(varServiceTimeCheckingBags / numReplications);
ciServiceTimeCheckingBags = [meanServiceTimeCheckingBags - ciHalfWidthServiceTimeCheckingBags, meanServiceTimeCheckingBags + ciHalfWidthServiceTimeCheckingBags];

fprintf('95%% Confidence Interval for Service Time to Check Bags: [%.4f, %.4f]\n', ciServiceTimeCheckingBags(1), ciServiceTimeCheckingBags(2));

% Confidence interval for wait times
ciHalfWidthServiceTimeProblems = tinv(1-alpha/2, df) * sqrt(varServiceTimeProblems/ numReplications);
ciServiceTimeProblems = [meanServiceTimeProblems - ciHalfWidthServiceTimeProblems, meanServiceTimeProblems + ciHalfWidthServiceTimeProblems];

fprintf('95%% Confidence Interval for Service Time Incase of Problems: [%.4f, %.4f]\n', ciServiceTimeProblems(1), ciServiceTimeProblems(2));

% Confidence interval for wait times
ciHalfWidthServiceTimeScreening = tinv(1-alpha/2, df) * sqrt(varServiceTimeScreening / numReplications);
ciServiceTimeScreening = [meanServiceTimeScreening - ciHalfWidthServiceTimeScreening, meanServiceTimeScreening + ciHalfWidthServiceTimeScreening];

fprintf('95%% Confidence Interval for Service Time for Screening: [%.4f, %.4f]\n', ciServiceTimeScreening(1), ciServiceTimeScreening(2));




% Plot Average Wait Time
figure; % Creates a new figure window
plot(1:numReplications, waitTimesArray, '-o');
title('Average Wait Time across Replications');
xlabel('Replication Number');
ylabel('Wait Time (minutes)');
grid on;

% Plot Utilization
figure; 
plot(1:numReplications, utilizationsArray, '-o');
title('Average Utilization across Replications');
xlabel('Replication Number');
ylabel('Utilization');
grid on;

% Plot Idle Time
figure;
plot(1:numReplications, idleTimesArray, '-o');
title('Average Idle Time across Replications');
xlabel('Replication Number');
ylabel('Idle Time (minutes)');
grid on;

% Plot Revenue
figure;
plot(1:numReplications, revenuesArray, '-o');
title('Average Revenue across Replications');
xlabel('Replication Number');
ylabel('Revenue ($)');
grid on;

% Plot Cost
figure;
plot(1:numReplications, costsArray, '-o');
title('Average Cost across Replications');
xlabel('Replication Number');
ylabel('Cost ($)');
grid on;

% Plot Profits
figure;
plot(1:numReplications, profitsArray, '-o');
title('Average Profits across Replications');
xlabel('Replication Number');
ylabel('Profits ($)');
grid on;

% Plot Service Time
figure;
plot(1:numReplications, servicetimeArray, '-o');
title('Average Service Time across Replications');
xlabel('Replication Number');
ylabel('Service Time (minutes)');
grid on;

% Plot Service Time for each Service
figure;
plot(1:numReplications, servicetimeBoardingArray, '-o', ...
     1:numReplications, servicetimeCheckingBagsArray, '-+', ...
     1:numReplications, servicetimeProblemsArray, '-*', ...
     1:numReplications, servicetimeScreeningArray, '-.');
legend('Boarding Pass', 'Checking Bags', 'Problems and Delays', 'Screening');
title('Average Service Time for Each Service across Replications');
xlabel('Replication Number');
ylabel('Service Time (minutes)');
grid on;






