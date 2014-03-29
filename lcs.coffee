argv = (require 'yargs').argv

# Check to make sure we have two valid strings to check
if (not argv._[0]?) or (not argv._[1]?) or (argv._.length isnt 2)
  console.log "Usage: coffee lcs.coffee <string1> <string2>"
  process.exit 1

# Get the two strings we're comparing.
# Cast to a string if necessary.
str1 = "" + argv._[0]
str2 = "" + argv._[1]

# The longer string of the two will be used as the 
# foundation for common string searches.
#
# longString will also be str1 if the two strings 
# are of equal length.
longString = (if str1.length >= str2.length then str1 else str2)
shortString = (if longString is str1 then str2 else str1)

# If the shorter string is in the longer string 
# (or the two strings are equivalent), then return
# shortString.
if (longString.indexOf shortString) isnt -1
  console.log shortString
  process.exit 0

# Easy part is over. Now loop backwards (from shortString.length)
# using chunks of shortString and offsetting.
# 
# Algorithm visualization:
#
# longString:  abcdefghij
#              0123456789
#
# shortString: qzydefghi     |                                                   |   longString.indexOf 'qzydefghi' = -1
#                            |                                                   |   (No luck; start chunking up shortString.)
#
#              qzydefgh      | chunkLength = 8, numChunks = 2, chunkOffset = 0   |   longString.indexOf 'qzydefgh' = -1
#               zydefghi     | chunkLength = 8, numChunks = 2, chunkOffset = 1   |   longString.indexOf 'zydefghi' = -1
#
#              qzydefg       | chunkLength = 7, numChunks = 3, chunkOffset = 0   |   longString.indexOf 'qzydefg' = -1
#               zydefgh      | chunkLength = 7, numChunks = 3, chunkOffset = 1   |   longString.indexOf 'zydefgh' = -1
#                ydefghi     | chunkLength = 7, numChunks = 3, chunkOffset = 2   |   longString.indexOf 'ydefghi' = -1
#
#              qzydef        | chunkLength = 6, numChunks = 4, chunkOffset = 0   |   longString.indexOf 'qzydef' = -1
#               zydefg       | chunkLength = 6, numChunks = 4, chunkOffset = 1   |   longString.indexOf 'zydefg' = -1
#                ydefgh      | chunkLength = 6, numChunks = 4, chunkOffset = 2   |   longString.indexOf 'ydefgh' = -1
#                 defghi     | chunkLength = 6, numChunks = 4, chunkOffset = 3   |   longString.indexOf 'defghi' = 3 
#                            |                                                   |   (YAY!)

# [Premature?] optimization: assign shortString.length to a variable
# so we don't call it every time we loop.
shortStringLength = shortString.length


for chunkLength in [shortStringLength-1..1]

  # Get the number of possible chunks in the current iteration.
  numChunks = (shortStringLength - chunkLength) + 1

  chunkArray = []

  for chunkOffset in [0..numChunks-1]
    chunkArray.push (shortString.substring chunkOffset, chunkOffset + chunkLength)

  for chunk in chunkArray
    if (longString.indexOf chunk) isnt -1
      console.log chunk
      process.exit 0

console.log 'No common substring found.'
process.exit 0









