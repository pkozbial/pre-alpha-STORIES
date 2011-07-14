#!/usr/bin/ruby


module Text

  def self.prefixTextLines( text, prefix )
    out = ''
    text.each_line() do |line|
      out += prefix+line
    end
    return out
  end
  
  def self.prefixTextLinesButFirst( text, prefix )
    out = ''
    first = true
    text.each_line() do |line|
      if first
        out = line
        first = false
      else
        out += prefix+line
      end
    end
    return out
  end
  
  def self.makeTextBold( text )
    return "\e[1m#{text}\e[0m"
  end

  def self.makeTextColor( text, color )
    if color == 'red'
      return "\e[31m#{text}\e[0m"
    elsif color == 'blue'
      return "\e[34m#{text}\e[0m"
    elsif color == 'cyan'
      return "\e[36m#{text}\e[0m"
    elsif color == 'green'
      return "\e[32m#{text}\e[0m"
    elsif color == 'magenta'
      return "\e[35m#{text}\e[0m"
    elsif color == 'white'
      return "\e[37m#{text}\e[0m"
    else
      print "UNKNOWN COLOR '#{color}'\n"
      exit 1
    end
  end

end

