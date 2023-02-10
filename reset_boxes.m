function reset_boxes(port)
%reset_boxes(port)
%
% Reset all available boxes.
%
% Input:
%   port:    serial port object handle
%
write(port, zeros(5, 1), 'uint8');
end