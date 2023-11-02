function throw_warning(message)

msgfig = msgbox('Warnung', message, 'modal');
uiwait(msgfig);

end