function answer = activate_boxes(port, boxes)
%activate_boxes(port, boxes)
% Activate MEA boxes for a single measurement defined by indices in array
% BOXES.
%
% Input:
% port........serialport object
% boxes.......4x1 array with logical address of electrode A, B, M, N
%

assert(length(boxes) == 4);

a = boxes(1);
b = boxes(2);
m = boxes(3);
n = boxes(4);

assert(a ~= b && a ~= m && a ~= n);
assert(b ~= m && b ~= n);
assert(m ~= n);


write(port, [0, a, b, m, n], 'uint8');

while port.NumBytesAvailable < 8
    pause(0.01);
end

ok = read(port, port.NumBytesAvailable, 'uint8');

ok1 = isequal([a, b, m, n], ok(1:2:8));

if b > 0
    ok2 = isequal([136, 72, 40, 24], ok(2:2:8));
else
    ok2 = isequal([136, 64, 40, 24], ok(2:2:8));
end

answer = ok1 && ok2;

% ok = answer(1) == n && answer(2) == bitor(128, bit);

% a_ok = set_and_verify(port, a, 'A', 'on');

% if b > 0
% %     b_ok = set_and_verify(port, b, 'B', 'on');
% else
%     b_ok = true;
% end

% m_ok = set_and_verify(port, m, 'M', 'on');
% n_ok = set_and_verify(port, n, 'N', 'on');

% ok = a_ok && b_ok && m_ok && n_ok;

end