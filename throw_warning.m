function throw_warning(message)
% throw_warning Throw a warning message and pause execution
%
msgfig = msgbox(message, 'Warnung', 'modal');
uiwait(msgfig);

end