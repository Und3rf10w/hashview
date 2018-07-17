# encoding: utf-8
get '/pcaps/list' do
  @hub_settings = HubSettings.first
  @customers = Customers.order(Sequel.asc(:name)).all
  @pcaps = Pcaps.all
  @cracked_status = {}
  @local_cracked_cnt = {}
  @local_uncracked_cnt = {}

  @pcaps.each do |pcap|
    pcap_cracked_count = HVDB.fetch('SELECT COUNT(p.originalpcap) as count FROM handshakes p LEFT JOIN pcaphandshakes a ON p.id = a.handshake_id WHERE (a.pcapfile_id = ? AND p.cracked = 1)', pcap.id)[:count]
    pcap_cracked_count = pcap_cracked_count[:count]
    pcap_total_count = HVDB.fetch('SELECT COUNT(p.originalpcap) as count FROM handshakes p LEFT JOIN pcaphandshakes a ON p.id = a.handshake_id WHERE a.pcapfile_id = ?', pcap.id)[:count]
    pcap_total_count = pcap_total_count[:count]
    @local_cracked_cnt[pcap.id] = pcap_cracked_count.to_s
    @local_uncracked_cnt[pcap.id] = pcap_total_count.to_i - pcap_cracked_count.to_i
    @cracked_status[pcap.id] = pcap_cracked_count.to_s + '/' + pcap_total_count.to_s
  end

  haml :pcap_list
end

get '/pcaps/delete' do
  varWash(params)

  pcaphandshakes = HVDB[:pcaphandshakes]
  pcaphandshakes.filter(pcap_id: params[:pcap_id]).delete

  pcap = HVDB[:pcaps]
  pcap.filter(id: params[:pcap_id]).delete

  flash[:success] = 'Successfully removed pcap.'

  redirect to('/pcaps/list')
end