require 'sinatra'
require 'json'

post '/words.json' do
  # Takes a JSON array of English-language words and adds them to the corpus (data store).
  response = JSON.parse(request.body.read)

  add_words(response["words"])

  status 201
end

get '/anagrams/:word.json' do
  # This endpoint should support an optional query param that indicates the maximum number of results to return.

  word = params[:word].to_s

  anagrams = { anagrams: find_anagrams(word) }

  return JSON.generate(anagrams)

  status 200
end

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

def split_word(word)
  word.split(//).sort
end

def find_anagrams(word)
  @test_word = split_word(word)

  anagrams = []

  File.readlines("dictionary.txt").each do |entry|
    entry = entry.gsub("\n", "")

    if entry.length == @test_word.length
      if entry.split(//).sort == @test_word
        if entry != word
          anagrams << entry
        end
      end
    end
  end
  anagrams
end

find_anagrams("read")
