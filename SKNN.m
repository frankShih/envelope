
% Author: Albert Haque
% Date: April 2014
% Twitch Plays Pokemon, Machine Learns Twitch

% This function performs sum of k nearest neighbors distance calculation

function [ anomalyScores ] = SKNN( k, distanceMatrix)
% Input: k = will compute sum up to kth nearest neighbor
% Output: list of anomaly scores. same order as row index in featureMatrix
numUsers = length(distanceMatrix);

if any(distanceMatrix(:)>0)    
    % Find the distance to k nearest neighbor
    sknn_distances = NaN(1,numUsers);
    for i = 1:numUsers
        sorted = sort(distanceMatrix(i,:));
        % Need to add 1 because there exists a 0 distance in the sorted list
        % (the distance of the point to itself)
        sknn_distances(i) = sum(sorted(1:k+1));
    end

    %anomalyScores = normalizeToAnomalyScore(sknn_distances);

    anomalyScores = sknn_distances / norm(sknn_distances);

else
    anomalyScores = zeros(1,numUsers);
end

end
