class LinkHighlighter
  attr_accessor :text
  
  def initialize(text)
    self.text = text.to_s
  end
  
  def to_s
    link_regex = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
    text.gsub(link_regex) do |match|
      if match =~ /^https?:\/\//
        real_link = match.to_s
      else
        real_link = "http://" + match.to_s unless match =~ /^https?:\/\//
      end
      
      "<a href=\"#{real_link}\">#{match.to_s}</a>"
    end
  end
end
