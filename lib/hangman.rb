require "json"
#rewrite attribute accessor to enable json

class Hangman
  attr_accessor :current_word, :guess_word

  def initialize(current_word, guess_word)
    @current_word = current_word
    @guess_word = guess_word

    until @current_word.length >= 5 && @current_word.length <= 11
      set_current_word(generate_word)
    end

    set_guess_word
  end

  #if given char is not included current word => if wont execute (nil)
  def guess_character(character)
    current_word = @current_word.split("")

    current_word.each_with_index do |word, index|
      if word == character
        @guess_word[index] = character
      end
    end
  end

  def compare_current_guess_word
    return true if current_word == guess_word
  end

  #needs to be private
  def set_current_word(word)
    @current_word = word
  end

  private

  def generate_word
    text = File.open("5desk.txt", "r")
    random_number = Random.new
    random_number = random_number.rand(61406)
    word = text.readlines[random_number].chomp.downcase
  end

  def set_guess_word
    guess_word = current_word
    @guess_word = guess_word.gsub(/[A-Za-z]/, "-")
  end
end


class Game
  attr_accessor :guesses, :characters_already_chosen

  def initialize
    if(File.exist?("save.json"))
      @h1 = Hangman.new("", "")
      load_game
      play_a_game
    else
      @h1 = Hangman.new("", "")
      @characters_already_chosen = []
      set_guesses
      play_a_game
    end
  end

  def play_a_game
    puts "The word was choosen!"

    until @h1.compare_current_guess_word || (guesses <= 0)
      puts "You have #{guesses} guesses left!"

      play_a_turn
      
      decrease_guesses

      save_game
    end

    puts "The answer was #{@h1.current_word}!"

    remove_save_data
  end

  def play_a_turn
    puts "Enter your char to take a guess! The word: #{@h1.guess_word}"
    players_choice = gets.chomp.downcase

    p set_character_already_chosen(players_choice)

    @h1.guess_character(players_choice)
  end

  def save_game
    save = File.open("save.json", "w")

    save.puts JSON.dump ({
      :current_word => @h1.current_word,
      :guess_word => @h1.guess_word,
      :guesses => @guesses,
      :characters_already_chosen => @characters_already_chosen
    })

    save.close
  end

  #currently the current instance of h1 is overwritten instead of initializing
  #a new object out of the hangman class
  def load_game
    save = File.open("save.json", "r")
    
    data = JSON.load(save.read)
    @h1.current_word = data["current_word"]
    @h1.guess_word = data["guess_word"]
    @guesses = data["guesses"]
    @characters_already_chosen = data["characters_already_chosen"]
  
    save.close
  end

  private

  def decrease_guesses
    @guesses -= 1
  end

  def set_guesses
    @guesses = @h1.current_word.length
  end

  def set_character_already_chosen(character)
    @characters_already_chosen << character
  end

  def remove_save_data
    File.delete("save.json")
  end

end

game = Game.new


