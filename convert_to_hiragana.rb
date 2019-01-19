require 'net/http'
require 'uri'
require 'json'

APP_ID = 'e845ac6b4d4b0127b9ee1702b3671f46cf21e6d65d8319f691a36e947e19cbe5'
API_URL = 'https://labs.goo.ne.jp/api/hiragana'

Dir.glob('./*/transcript_utf8.txt').each do |relative_path|
  File.open(relative_path.gsub(/transcript/, 'rb_converted_transcript'), 'w') do |out_f|
    puts(relative_path)
    File.open(relative_path) do |in_f|
      in_f.each do |line|
        id, sentence = line.split(':')
        puts sentence

        params = {
          app_id: APP_ID,
          sentence: sentence,
          output_type: 'hiragana'
        }

        sleep(2)
        res = Net::HTTP.post_form(URI.parse(API_URL), params)

        next unless parsed = JSON.parse(res.body)['converted']

        converted_sentence = parsed.gsub(/\s+/, "")
        puts converted_sentence
        out_f.puts("#{id} #{converted_sentence}")
      end
    end
  end
end

# File.open('converted.txt', 'a') do |out_f|
#   File.open('example.txt', 'a+') do |in_f|
#     in_f.each_line do |line|
#       params = {
#         app_id: APP_ID,
#         sentence: line,
#         output_type: 'hiragana'
#       }
#
#       res = Net::HTTP.post_form(URI.parse(API_URL), params)
#       converted_sentence = JSON.parse(res.body)['converted'].gsub(/\s+/, "")
#       out_f.puts(converted_sentence)
#     end
#   end
# end
