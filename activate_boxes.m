function answer = activate_boxes(port, boxes)
%activate_boxes(port, boxes)
% Activate MEA boxes for a single measurement defined by indices in array
% BOXES.
%
% Input:
% port........serialport object
% boxes.......4x1 array with logical address of electrode A, B, M, N
%
% The 4x1 array BOXES contains in each element the number of the individual
% boxes that act as electrode A, B, M or N.
%
% On initialization, the sequence [0, A, B, M, N] is written to the serial
% port.
% The boxes copy their individual number followed by a byte indicating
% whether the relais associated with A, B, M, or N is activated or not.

assert(length(boxes) == 4);

a = boxes(1);
b = boxes(2);
m = boxes(3);
n = boxes(4);

assert(a ~= b && a ~= m && a ~= n);
assert(b ~= m && b ~= n);
assert(m ~= n);

if all(boxes)
    write(port, [0, a, b, m, n], 'uint8');
    while port.NumBytesAvailable < 8
        pause(0.01);
    end
    ok = read(port, port.NumBytesAvailable, 'uint8');
    % The array `ok` is an 8x1 array of uint8.
    % It contains 4 pairs of address and return value for the electrodes A, B, M,
    % and N
    % First, check that the addresses are copied correctly:
    %
    ok1 = isequal([a, b, m, n], ok(1:2:8));
    % Next, check the return codes.
    % If A, B, M, N are `on` the four bytes return
    % 136, 72, 40 and 24, respectively
    % Expressed in binary format:
    % ABMNx000, where bit x contains 1 for `on` or 0 for `off`
    %
    
    if b > 0 % 4 electrodes
        ok2 = isequal([136, 72, 40, 24], ok(2:2:8));
    else % 3 electrodes
        ok2 = isequal([136, 64, 40, 24], ok(2:2:8));
    end

elseif isequal(b, 0)
    % For pole-dipole configurations it is assumed that electrode B
    % is never activated in any box.
    % In that case we expect that the state of the relais for b is OFF.
    % Hence, B can be ignored.
    %
    write(port, [0, a, b, m, n], 'uint8');
    while port.NumBytesAvailable < 6
        pause(0.01);
    end
    ok = read(port, port.NumBytesAvailable, 'uint8');
    ok1 = isequal([a, m, n], ok(1:2:6));
    ok2 = isequal([136, 40, 24], ok(2:2:6));
end

% Return true if both checks are ok.
%
answer = isequal(ok1, ok2);

end