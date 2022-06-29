function S = read_syscal(port)
% read_syscal Retrieve data from SYSCAL memory
%
% port.......serialport object
%
% Return value:
% S........15x1 array
%

writeline(port, "R000");

while port.NumBytesAvailable == 0
    pause(0.01);
end

S = zeros(15, 1);

for k = 1:15
    S(k) = readline(port);
end