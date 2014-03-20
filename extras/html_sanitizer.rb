class HtmlSanitizer
  attr_accessor :text
  
  def initialize(text)
    self.text = text.to_s
  end
  
  def to_s
    text.gsub("<", '&lt;').gsub(">", '&gt;')
  end
end
