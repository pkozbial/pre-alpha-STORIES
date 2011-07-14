#!/usr/bin/ruby

module Parser

  # returns array of triples (tag name, tag content, tag line)
  def self.parse( text )
  
    tags = []
  
    current_tag_name = nil
    current_tag_content = ''
    current_tag_line = nil
  
    text.each_line() do |line|
      line.chomp!
      if line =~ /^\s*<\/([^ >]*)/ and $1 != 'object'
        if $1 == current_tag_name
          tags += [[current_tag_name, current_tag_content, current_tag_line]]
        else
          print "ERROR - TAG MISMATCH: opened '#{current_tag_name}', closed with '#{$1}'\n"
          exit 1
        end
      elsif line =~ /^\s*<([^ >]*)/ and $1 != 'object'
        current_tag_name = $1
        current_tag_content = ''
        line =~ /<([^>]*)/
        current_tag_line = $1
      else
        current_tag_content += line+"\n"
      end
    end
  
    return tags
  end

  def self.getShort( parsedText )
    parsedText.each do |tag| (tag_name, tag_contents, tagline) = tag
      if tag_name == 'short'
        tag_contents.each_line { |line| return line.chomp }
        return nil
      end
    end
    return nil
  end

  def self.getDir( parsedText )
    parsedText.each do |tag| (tag_name, tag_contents, tagline) = tag
      if tag_name == 'dir'
        tag_contents.each_line { |line| return line.chomp.gsub( /^\s+/, '' ).gsub( /\s+/, '' ) }
        return ''
      end
    end
    return ''
  end

  def self.getLastTagNamed( parsedText, tagName )
    out = nil
    parsedText.each do |tag| (name,contents,tagline) = tag
      if name == tagName
        out = tag
      end
    end
    return out
  end

  # returns subarray from last tag with the given name to the end of table
  def self.subFromLastTagNamed( parsedText, tagName )
    n = 0
    found = false
    out = []
    parsedText.each do |tag| (name,contents,tagline) = tag
      if name == tagName
        found = true
        out = [tag]
      elsif found
        out += [tag]
      end
    end
    return found ? out : nil
  end

  # returns:
  # (
  #    bool:  has actions
  #    bool:  has expects
  #    bool:  first is action (meaningful only if two first are true)
  #    Date:  soonest action (or nil)
  #    Date:  soonest expect (or nil)
  # ) 
  def self.checkActionsExpects( parsedText )
    hasActions = false
    hasExpects = false
    actionFirst = nil
    soonestAction = nil
    soonestExpect = nil
    parsedText.each do |tag| (name,contents,tagline) = tag
      if name == 'action'
        hasActions = true
        if actionFirst == nil
          actionFirst = true
        end
        if tagline =~ /action\s+(\S+)/
          d = nil
          if $1 == '*'
            d = PK::DateTime::DateUtils::DateParser::parseSimple( '9999-01-01' )
          else
            d = PK::DateTime::DateUtils::DateParser::parseSimple( $1 )
          end
          if d != nil and (soonestAction == nil or d < soonestAction)
            soonestAction = d
          end
        end 

      elsif name == 'expect'
        hasExpects = true
        if actionFirst == nil
          actionFirst = false
        end
        if tagline =~ /expect\s+(\S+)/
          if $1 == '*'
            d = PK::DateTime::DateUtils::DateParser::parseSimple( '9999-01-01' )
          else
            d = PK::DateTime::DateUtils::DateParser::parseSimple( $1 )
          end
          if d != nil and (soonestExpect== nil or d < soonestExpect)
            soonestExpect = d
          end
        end 
      end

    end
    return [ hasActions, hasExpects, actionFirst, soonestAction, soonestExpect ]
  end

end

