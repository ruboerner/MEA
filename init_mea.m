function port = init_mea(com)
% init_mea Initialize serial port for communication with MEA
%
% port = init_mea(com)
%
% com...... string, e.g., 'COM3'
%
% Returns a serialport object.
%
port = serialport(com, 4800);
configureTerminator(port, "CR/LF");
