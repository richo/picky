class Object # :nodoc:all
  
  # Puts a text in the form:
  #   12:34:56: text here
  #
  def timed_exclaim text
    exclaim "#{Time.now.strftime("%H:%M:%S")}: #{text}"
  end
  
  # Just puts the given text.
  #
  def exclaim text
    puts text
  end
  
  # Puts a text that informs the user of a missing gem.
  #
  def puts_gem_missing gem_name, message
    puts "#{gem_name} gem missing!\nTo use #{message}, you need to:\n  1. Add the following line to Gemfile:\n     gem '#{gem_name}'\n  2. Then, run:\n     bundle update\n"
  end
  
end