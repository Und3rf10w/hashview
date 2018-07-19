# encoding : utf-8
require 'base64'


def importHandshake(handshake)


end


def getMode(handshake)
  @modes = []
  @modes.push('2500') # WPA/WPA2
  @modes.push('2501') # WPA/WPA2 PMK
end


def modeToFriendly(mode)
  return 'WPA/WPA2' if mode == '2500'
  return 'WPA/WPA2 PMK' if mode == '2501'
end


def friendlyToMode(friendly)
  return '2500' if friendly = 'WPA/WPA2'
  return '2501' if friendly = 'WPA/WPA2 PMK'
end
