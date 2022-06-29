function ok = set_and_verify(port, n, type, onoff)
% set_and_verify(port, n, type, onoff)
%
% Example:
% =======
% ok = set_and_verify(RS485, 12, 'A', 'on');
% 
% Switch on relais 'A' in box 12.
% Returns 1 if operation was successful.
%

assert(ischar(type), 'type must be a character');
assert(ischar(onoff), 'onoff must be either ''on'' or ''off''.');
assert(n > 0, 'n must be > 0!');

if strcmpi(onoff, 'on')
    bit = 8;
elseif strcmpi(onoff, 'off')
    bit = 0;
else
    warning('Electrode state not recognized. Setting to ''off''.');
    bit = 0;
end

switch lower(type)
    case 'a'
        write(port, [0, n, 0, 0, 0], 'uint8');
        while port.NumBytesAvailable < 2
            pause(0.01)
        end
        answer = read(port, 2, 'uint8');
        ok = answer(1) == n && answer(2) == bitor(128, bit);
    case 'b'
        write(port, [0, 0, n, 0, 0], 'uint8');
        while port.NumBytesAvailable < 2
            pause(0.01)
        end
        answer = read(port, 2, 'uint8');
        ok = answer(1) == n && answer(2) == bitor(64, bit);
    case 'm'
        write(port, [0, 0, 0, n, 0], 'uint8');
        while port.NumBytesAvailable < 2
            pause(0.01)
        end
        answer = read(port, 2, 'uint8');
        ok = answer(1) == n && answer(2) == bitor(32, bit);
    case 'n'
        write(port, [0, 0, 0, 0, n], 'uint8');
        while port.NumBytesAvailable < 2
            pause(0.01)
        end
        answer = read(port, 2, 'uint8');
        ok = answer(1) == n && answer(2) == bitor(16, bit);
    otherwise
        error('Electrode type not recognized.')
end
pause(0.1);
end