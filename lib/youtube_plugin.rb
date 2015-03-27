require 'open-uri'
require 'nokogiri'

module Schnapsdrossel
  class YoutubePlugin
    include Cinch::Plugin
  
    match %r!(?:\A|\s)(https?://\S*youtu[\.]?be\S+)(?:\z|\s)!i, use_prefix: false
    
    def execute(m, url)
      data = Nokogiri::HTML(open(url))
      title = data.title.gsub(/ - YouTube$/, '')
      duration = nil
      data.css('[itemprop="duration"]').first['content'].gsub(/PT(\d+)M(\d+)S/) do |_|
        minutes, seconds = $1.to_i, $2.to_i
        if minutes >= 60
          duration = "%.2i:%.2i:%.2i" % [minutes / 60, minutes % 60, seconds]
        else
          duration = "%.2i:%.2i" % [minutes, seconds]
        end
      end
      m.channel.msg("YouTube: #{title} (#{duration})")
    end

  end

end
