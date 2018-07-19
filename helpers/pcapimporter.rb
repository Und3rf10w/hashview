# encoding : utf-8
require 'base64'


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


def addHandshake(handshake, hashtype)
	entry = Handshakes.new
	entry[:encodedhandshake] = Base64.encode64(handshake)
	entry[:hashtype] = hashtype
	entry[:cracked] = false
	entry.save
end

def updatePcapFileHandshakes(handshake_id, essid, pcap_id)
	entry = Pcapfilehandshakes.new
	entry[:handshake_id] = handshake_id
	entry[:ssid] = essid
	entry[:pcap_id] = pcap_id
	entry.save
end

def importHccapx(handshake, pcap_id, type)
	a = Hccapx.new

	@handshake_id = Handshakes.first(encodedhandshake: Base64.encode64(handshake), hashtype: type)
	if @handshake_id.nil?
		addHandshake(handshake, type)
		@handshake = Handshakes.first(encodedhandshake: Base64.encode64(handshake), hashtype: type)
	elsif @handshake_id && handshake_id[:hashtype].to_s != type.to_s
		unless @handshake_id[:cracked]
			@handshake_id[:hashtype] = type.to_i
			@handshake_id.save
		end
	end
	updatePcapFileHandshakes(@handshake_id.id.to_i, a.read(handshake).essid, pcap_id)
end

def importHandshake(handshake, file_type, pcap_id, hashtype)
  if file_type == 'hccapx'
  	importHccapx(handshake, pcap_id, hashtype)
  else
  	return 'Unsupported pcap format detected'
  end
end