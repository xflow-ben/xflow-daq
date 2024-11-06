% Compare fatigue

% Cumulative fatigue load spectrum
% Fatigue range (moment or force) vs number of cycles in that bin of force
% log on x (num cycles) linnear on y (force amplitude)
load_bins = 50;
load('X:\Experiments and Data\20 kW Prototype\Loads_Data\operating_uncompressed\processed\operating_results_1014180631.mat')

Mx = results.td.Lower_Arm_Mx;

[counts, ex, ey] = raincount(Mx);

binEdges = linspace(min(counts(:,2)),max(counts(:,2)),load_bins+1);
[~,~,bin] = histcounts(counts(:,2),binEdges);

N = [];
for i = 1:length(binEdges) - 1
    N(i) = sum(counts(bin == i,1));
end

binCenters = binEdges(1:end-1) + diff(binEdges);
figure;
semilogx(N,binCenters,'o-')


My = results.td.Lower_Arm_My;

[counts, ex, ey] = raincount(My);

binEdges = linspace(min(counts(:,2)),max(counts(:,2)),load_bins+1);
[~,~,bin] = histcounts(counts(:,2),binEdges);

N = [];
for i = 1:length(binEdges) - 1
    N(i) = sum(counts(bin == i,1));
end

binCenters = binEdges(1:end-1) + diff(binEdges);
figure;
semilogx(N,binCenters,'o-')
