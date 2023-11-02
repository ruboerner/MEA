function throw_warning(message)

msgfig = msgbox(message, 'Warnung', 'modal');
uiwait(msgfig);

end