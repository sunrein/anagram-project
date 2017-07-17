require 'sinatra'
require 'json'

post '/words' do
  # Takes a JSON array of English-language words and adds them to the corpus (data store).
  response = JSON.parse(request.body.read)

  add_words(response["words"])
end

# get '/anagrams/:word' do
#   params[:word, :max]
#   # Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
#   # This endpoint should support an optional query param that indicates the maximum number of results to return.

#   # set parameters for the route
#   # write a method that breaks up the given word (word.split.sort)
#   # iterate through dictionary, first checking if each word matches the length of the given word, then (word.split.sort)
#   # that word and compares the two arrays
# end

# delete '/words/:word' do
#   params[:word]
#   # Deletes a single word from the data store.

#   # find that word in the dictionary
#   # delete that word
# end

# delete '/words' do
#   # Deletes all contents of the data store.

#   # delete all of the words!
# end

def add_words(words)
  File.open("dictionary.txt", "a") do |file|
    file.puts(words)
  end
end
