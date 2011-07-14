#!/usr/bin/ruby

currentPosition = `cat .current`.to_i

if currentPosition > 0
  thisFname = `fname #{currentPosition}`.chomp
  nextFname = `fname #{currentPosition+1}`.chomp
  `mv #{thisFname} .mup.tmp`
  `mv #{nextFname} #{thisFname}`
  `mv .mup.tmp #{nextFname}`
  exit 0
else
  exit 1
end

