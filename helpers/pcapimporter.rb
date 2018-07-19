# encoding : utf-8
require 'bindata'
require 'base64'


class Hccapx < BinData::Record
	endian :big
	uint32 :signature
	uint32 :version
	uint8 :message_pair
	uint8 :essid_len
	string :essid, :length => 32, :trim_padding => true
	uint8 :keyver
	uint8 :keymic, :length => 16
	uint8 :mac_ap, :length => 6
	uint8 :nonce_ap, :length => 32
	uint8 :mac_sta, :length => 6
	uint8 :nonce_sta, :length => 32
	uint16 :eapol_len
	uint8 :eapol, :length => 256
end


def ssid(ssid)
  ssid =~ /\$/ ? true : false
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
