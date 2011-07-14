#!/usr/bin/ruby

require './bin/Parser.rb'

module Sort
  def self.ordinal( rawText, parsedText )

    ( hasActions, hasExpects, actionFirst, soonestAction, soonestExpect ) =
      Parser::checkActionsExpects( parsedText );

    soonestDate = nil
    if hasActions
      soonestDate = soonestAction
    end
    if hasExpects
      if soonestDate == nil or soonestExpect < soonestDate
        soonestDate = soonestExpect
      end
    end

    if soonestDate == nil
      if hasActions
        return 1 * 10000 * 800
      elsif hasExpects
        return 2 * 10000 * 800
      else
        return 3 * 10000 * 800
      end
    else
      return (soonestDate.year * 800) + (soonestDate.month * 40) + (soonestDate.day)
    end
  end
end


