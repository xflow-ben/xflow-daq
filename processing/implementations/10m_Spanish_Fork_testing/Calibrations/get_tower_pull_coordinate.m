function theta = get_tower_pull_coordinate(dA,dB,dC,A,B,C,tol)

for II = 1:length(dA)
    if isnan(dA(II)) && isnan(dB(II)) && isnan(dC(II))
        coordinate(II,:) = [NaN, NaN, NaN];
    else
        coordinate(II,:) = get_pull_coordiante_3D(A,C,B,...
            dA(II),dC(II),dB(II),tol);
    end
end

theta = atand(coordinate(:,2)./ coordinate(:,1));

end

function coordinate = get_pull_coordiante_3D(A,B,C,dA,dB,dC,tol)
% Find x,y
coordinate = trilateration_2D_from_three_measurments(A,B,C,dA,dB,dC,tol);
end

function P_avg = trilateration_2D_from_three_measurments(A,B,C,dA,dB,dC,tol)
% Initialize a list to store the valid points
valid_points = [];

% 1. Check combinations of A, B, C using the helper function
% First combination: A and B with reference to C
valid_points = add_valid_points(A, B, dA, dB, C, dC, tol, valid_points);

% Second combination: A and C with reference to B
valid_points = add_valid_points(A, C, dA, dC, B, dB, tol, valid_points);

% Third combination: B and C with reference to A
valid_points = add_valid_points(B, C, dB, dC, A, dA, tol, valid_points);

% Check if valid points were found
if isempty(valid_points)
    error('No valid solutions: No points satisfied all distance constraints woth the tolerance provided.');
end

% Calculate the average of all valid points
P_avg = mean(valid_points, 1);
end

% Helper function to determine valid points and perform trilateration
function valid_points = add_valid_points(P1_coords, P2_coords, d1, d2, ref_point, ref_dist, tol, valid_points)
% Trilateration between two points
[P1, P2] = trilateration_2D(P1_coords, P2_coords, d1, d2);



% Check if the computed points match the reference distance
if abs(distance(P1, ref_point) - ref_dist) < tol
    valid_points = [valid_points; P1];
end
if abs(distance(P2, ref_point) - ref_dist) < tol
    valid_points = [valid_points; P2];
end
end

function [P1, P2] = trilateration_2D(A, B, dA, dB)
% Input:
% A  - [x_A, y_A], coordinates of point A
% B  - [x_B, y_B], coordinates of point B
% dA - distance from point P to A
% dB - distance from point P to B
%
% Output:
% P1, P2 - possible positions of the point P (there could be two solutions)

% Extract coordinates of points A and B
x_A = A(1); y_A = A(2);
x_B = B(1); y_B = B(2);

% Calculate distance between points A and B
d_AB = sqrt((x_B - x_A)^2 + (y_B - y_A)^2);

if dA + dB < d_AB || abs(dA - dB) > d_AB
    error('No solution: The circles do not intersect.');
end

% Midpoint between A and B
ex = (B - A) / d_AB;
x_m = (dA^2 - dB^2 + d_AB^2) / (2 * d_AB);

% Distance along the perpendicular axis
y_m = sqrt(dA^2 - x_m^2);

% First intersection point (P1)
P1 = A + x_m * ex + y_m * [ex(2), -ex(1)];

% Second intersection point (P2)
P2 = A + x_m * ex - y_m * [ex(2), -ex(1)];

end

function d = distance(P,Q)
% Function to check the distance between a point and a known point
d = sqrt((P(1) - Q(1))^2 + (P(2) - Q(2))^2);
end