#!/usr/bin/ruby

require 'net/http'
require 'securerandom'
require 'json'
@last_text = "Gg"
@uuid = SecureRandom.uuid
@id = "Your chat id"
Sessoins = Net::HTTPSession
@header = {'User-Agent' => 'Instagram 113.0.0.39.122 Android (24/5.0; 515dpi; 1440x2416; huawei/google; Nexus 6P; angler; angler; en_US)',
           'Accept' => '*/*',
           'Accept-Language' => 'en-US',
           'X-IG-Capabilities' => '3brTvw==',
           'X-IG-Connection-Type' => 'WIFI',
           'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
           'Host' => 'i.instagram.com'}
def send_request(url, post=nil)
  http = Sessoins.new("i.instagram.com", 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  if post
    request = Sessoins::Post.new(url, @header)
    request.body = post
  else
    request = Sessoins::Get.new(url, @header)
  end
  request.set_content_type("application/x-www-form-urlencoded; charset=UTF-8")
  response = http.request(request)
  return response
end
pust "Enter user:pass "
user = gets.chomp.split(':')
pust "\nThreadv2 ID : "
TID = gets.chomp
response = send_request("/api/v1/accounts/login/", "username=#{user[0]}&password=#{user[1]}&from_reg=false&device_id=#{@uuid}&_uuid=#{@uuid}&_csrftoken=SAEsY7ffVN12IG6J8JZ1j4Bx83j1GRou")
if response.body.include?("logged_in_user")
  all_cookies = response.get_fields('set-cookie')
  cookies_array = Array.new
  all_cookies.each do| cookie |
    cookies_array.push(cookie.split('; ')[0])
  end
  cookies = cookies_array.join('; ')
  @header.merge!('Cookie' => cookies)
  while true
    begin
      text = JSON.parse(send_request("/api/v1/direct_v2/threads/#{@id}/?use_unified_inbox=true").body)['thread']['items'][0]
      if text['text'] != @last_text
        send_request("/api/v1/direct_v2/threads/#{@TID}/items/#{text['item_id']}/seen/", "").body
        @last_text = text['text']
        if @last_text.include? "$add"
          send_request("/api/v1/direct_v2/threads/#{id}/add_user/", "_csrftoken=missing&user_ids=[\"#{text['text'].scan(/\d/).join("").to_s}\"]&_uuid=#{@uuid}&use_unified_inbox=true").body
          end
      end
      sleep(30)
    rescue
      exit 0
    end
  end
end
