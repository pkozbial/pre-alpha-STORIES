#!/usr/bin/ruby

require './bin/Parser.rb'

module Manager
  def self.eachDir( folder, dir )
    list = []
    `cd #{folder}; ls`.sort.each do |fname|
      fname.chomp!
      if fname =~ /^\d\d\d\d\d\d\.txt$/
        list += [fname]
      end
    end

    # map: dirname -> file list
    # root is dirname == ''
    dirs = {}
  
    list.each do |fname|
      rawText = `cat #{folder}/#{fname}`
      parsedText = Parser::parse( rawText )
      dirabs = Parser::getDir( parsedText )
      
      if dirabs.length > dir.length
        if dirabs[0, dir.length] == dir
          sdir = ''
          if dirabs[dir.length,1] == '/'
            sdir = dirabs[dir.length+1, dirabs.length]
          else 
            sdir = dirabs[dir.length, dirabs.length]
          end
          dirs[sdir] = 1  unless sdir =~ /\//
        end
      end

    end

    dirs.keys.sort.each { |dir| yield dir }
  end

  def self.eachStoryD( folder, dir )
    list = []
    `cd #{folder}; ls`.sort.each do |fname|
      fname.chomp!
      if fname =~ /^\d\d\d\d\d\d\.txt$/
        rawText = `cat #{folder}/#{fname}`
        parsedText = Parser::parse( rawText )
        if Parser::getDir( parsedText ) == dir
          list += [fname]
        end
      end
    end

    listSorted = nil 

    if File.exists?( './hooks/list-sort.rb' )
      require './hooks/list-sort.rb'  # gives us Sort module with method 'ordinal'
      listWithOrdinals = []
      list.each do |fname|
        rawText = `cat #{folder}/#{fname}`
        parsedText = Parser::parse( rawText )
        ordinal = Sort::ordinal( rawText, parsedText )
        listWithOrdinals += [[fname,ordinal]]
      end
      listWithOrdinals.sort! do |a,b|
        (fname1, ord1) = a
        (fname2, ord2) = b
        ord1 <=> ord2
      end

      listSorted = []
      listWithOrdinals.each do |elem|
        (fname, ord) = elem
        listSorted += [fname]
      end
    else
      listSorted = list
    end

    listSorted.each do |fname|
      text = `cat #{folder}/#{fname}`
      yield fname,text
    end


  end

  def self.eachStory( folder )
    self.eachStoryD( folder, '' ) { |fname,text| yield fname, text }
    self.eachDir( folder ) do |dir|
      self.eachStoryD( folder, dir ) { |fname,text| yield fname, text }
    end
  end

end

