require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @grid = params[:grid].split
    @guess = params[:guess]
    if included?(@guess, @grid)
      if english_word?(@guess)
        @score = "Congratulations, #{@guess} is a valid English word!"
      else
        @score = "Sorry, but #{@guess} does not seem to be an English word"
      end
    else
      @score = "Sorry, but #{@guess} cannot be built out of #{@grid.join(' ')}"
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
