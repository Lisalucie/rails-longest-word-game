Require 'json'
Require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times.map { @letters << ('A'..'Z').to_a.sample }
    # also works Array.new(10)
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    # need to call it to be able to use it in another method (with hidden field tag)
    @score =
      if built_with_existing_letters? == false
        "sorry but #{@answer} can't be built out of #{@letters}"
      elsif valid_english_word? == false
        "sorry but #{@answer} is not a valid english word..."
      else
        "Congratulations ! #{@answer} is a valid english word !"
      end
  end

  def valid_english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    dictionary = URI.parse(url).read
    word = JSON.parse(dictionary)
    word['found'] == true
    # no need for a if method
  end

  def built_with_existing_letters?
    # separate all the letters of answer, chars return array of str
    answer = @answer.upcase.chars.to_a
    # compare letters of answer to the letters in the random array
    answer.all? { |letter| @letters.include?(letter) }
  end
end
