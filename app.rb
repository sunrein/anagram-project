require 'sinatra'
require 'json'
require 'fileutils'

post '/words.json' do
  response = JSON.parse(request.body.read)

  add_words(response["words"])

  status 201
end

get '/anagrams/:word.json' do
  word = params[:word].to_s
  limit = params[:limit].to_i

  if limit
    limited_anagrams = { anagrams: find_anagrams(word).slice!(0..limit - 1) }
    return JSON.generate(limited_anagrams)
  else
    anagrams = { anagrams: find_anagrams(word) }
    return JSON.generate(anagrams)
  end

  status 200
end

delete '/words/:word.json' do
  word = params[:word]

  delete_word(word)

  status 204
end

delete '/words.json' do
  File.open('dictionary.txt', 'w') {}

  status 204
end

def add_words(words)
  File.open("dictionary.txt", "a") do |file|
    file.puts(words)
  end
end

def split_word(word)
  word.split(//).sort
end

def delete_word(word)
  File.open('dictionary.txt', 'r') do |original_file|
    File.open('dictionary.txt.tmp', 'w') do |new_file|
      original_file.each_line do |entry|
        new_file.write(entry) unless entry.gsub("\n", "") == word
      end
    end
  end

  FileUtils.mv 'dictionary.txt.tmp', 'dictionary.txt'
end

def find_anagrams(word)
  @given_word = split_word(word)

  anagrams = []

  File.readlines("dictionary.txt").each do |entry|
    entry = entry.gsub("\n", "")

    if entry.length == @given_word.length
      if split_word(entry) == @given_word
        if entry != word
          anagrams << entry
        end
      end
    end
  end
  anagrams
end
