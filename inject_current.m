function [ok, answer] = inject_current(port, cycles)
% inject_current Start measurement
%
% port.......serial port object
% cycles.....number of current injection cycles, scalar
%

assert(cycles > 2);

str = sprintf('I%02d', cycles);

writeline(port, str);
while port.NumBytesAvailable == 0
    pause(0.01);
end

ok = false;

if port.NumBytesAvailable > 0
    answer = readline(port);
    ok = true;
end

% if ~strcmp(answer, 'C')
%     % warning('Injection error.');
%     ok = false;
% end