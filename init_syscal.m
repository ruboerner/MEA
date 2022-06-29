function port = init_syscal(com, len)
% init_syscal Initialize serial port for communication with SYSCAL R2E
%
% port = init_syscal(com, len)
%
% com...... string, e.g., 'COM3'
% len...... scalar, 1 or 2. Injection pulse length in sec
%
% Returns a serialport object.
%

port = serialport(com, 1200);
configureTerminator(port, "CR/LF");

str = sprintf('T%d000', len);
writeline(port, str);

while port.NumBytesAvailable == 0
    pause(0.01);
end

if port.NumBytesAvailable > 0
    answer = readline(port);
end

if ~strcmp(answer, 'C')
    warning('Error.')
end

end
