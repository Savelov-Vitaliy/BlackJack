module GetPlayerAnswer

  def get_player_answer(*param)
    loop do 
      @input = gets.chomp.to_s
      break if param.include? @input
      puts "Incorrect answer."
      print "Try again: "
    end    
    @input
  end

end
