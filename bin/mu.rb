#!/usr/bin/ruby

currentPosition = `cat .current`.to_i

if currentPosition > 1
  thisFname = `fname #{currentPosition}`.chomp
  prevFname = `fname #{currentPosition-1}`.chomp
  `mv #{thisFname} .mup.tmp`
  `mv #{prevFname} #{thisFname}`
  `mv .mup.tmp #{prevFname}`
  exit 0
else
  exit 1
end

