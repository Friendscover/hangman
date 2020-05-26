#class Hangman (load file, select word, current word + guessed word)
#game class (hangman class, play_turns, get player input)
#save/load file

#refactor to attr accessor 
class Hangman
  def initialize
    @current_word = ""
    @guess_word = ""

    until @current_word.length >= 5 && @current_word.length <= 11
      set_current_word
    end

    set_guess_word
  end

  def get_current_word
    @current_word
  end

  def get_guess_word
    @guess_word
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
    return true if get_current_word == get_guess_word
  end

  private

  def set_current_word
    text = File.open("5desk.txt", "r")
    random_number = Random.new
    random_number = random_number.rand(61406)
    word = text.readlines[random_number].chomp
    @current_word = word
  end

  def set_guess_word
    current_word = get_current_word
    @guess_word = current_word.gsub(/[A-Za-z]/, "-")
  end
end

class Game
  def initialize
    @h1 = Hangman.new
    @characters_already_chosen = []

    set_guesses

    play_a_game
  end

  def get_guesses
    @guesses
  end

  def play_a_game
    puts "The word was choosen!"

    until @h1.compare_current_guess_word || (get_guesses < 0)
      play_a_turn
      
      decrease_guesses
    end

    puts "The answer was #{@h1.get_current_word}!"
  end

  def play_a_turn
    puts "Enter your char to take a guess! The word: #{@h1.get_guess_word}"
    players_choice = gets.chomp

    p set_character_already_chosen(players_choice)

    @h1.guess_character(players_choice)

    puts "You have #{get_guesses} guesses left!"
  end

  private

  def decrease_guesses
    @guesses -= 1
  end

  def set_guesses
    @guesses = @h1.get_current_word.length
  end

  def set_character_already_chosen(character)
    @characters_already_chosen << character
  end

end

game = Game.new


