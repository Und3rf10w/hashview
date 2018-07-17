# encoding : utf-8

def ssid(ssid)
  ssid =~ /\$/ ? true : false
end

def getMode(handshake)
  @modes = []
  @modes.push('2500') # WPA/WPA2
end

def modeToFriendly(mode)
  return 'WPA/WPA2' if mode == '2500'
end

def friendlyToMode(friendly)
  return '2500' if friendly = 'WPA/WPA2'
end

