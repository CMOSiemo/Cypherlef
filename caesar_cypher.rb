
#Languages supported
CODEBASE_ES = {name: "Español", chars: 27, lower: [97, 98, 99, 100, 101,
  102, 103, 104, 105, 106, 107, 108, 109, 110, 241, 111, 112, 113, 114, 115, 
  116, 117, 118, 119, 120, 121, 122], upper: [65, 66, 67, 68, 69, 70, 71, 
  72, 73, 74, 75, 76, 77, 78, 209, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
  90]}

CODEBASE_EN = {name: "English", chars: 26, lower: [97, 98, 99, 100, 101, 
  102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 
  117, 118, 119, 120, 121, 122], upper: [65, 66, 67, 68, 69, 70, 71, 72, 
  73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]}

def normalize_text(text)

  #Normalizes text by replacing common irregular spanish characters with analog
  text.gsub("á", "a").gsub("é", "e").gsub("í", "i").gsub("ó", "o").gsub("ú", 
  "u").gsub("Á", "A").gsub("É", "E").gsub("Í", "I").gsub("Ó", "O").gsub("Ú",
  "U")

end

def to_unicode_array(text)

  #Converts text's characters to their unicode values and stores them in an array
  holder = []
  text.each_codepoint { |char| holder << char }
  holder

end

def encode_char(lan, char_uni, key)
  
  #Checks wether unicode number is in CODEBASE_LAN[:lower]
  if lan[:lower].any? { |uni| char_uni == uni }

    #Since it is, iterate over it with index
    lan[:lower].each_with_index do |uni, idx|

      #and return new index encoded by key
      if char_uni == uni

        return lan[:lower][(idx + key) % lan[:chars]]

      end

    end 
      
  #Since it's not in [:lower], checks whether it's in [:upper]
  elsif  lan[:upper].any? { |uni| char_uni == uni }

    #Since it is, iterate over it with index
    lan[:upper].each_with_index do |uni, idx|

      #and return new index encoded by key
      if char_uni == uni

        return lan[:upper][(idx + key) % lan[:chars]]

      end

    end

  #Since it's neither in [:lower] nor [:upper], returns it unmodified
  else char_uni

  end

end

def array_operator(lan, array, key)
  
  #Iterates over the unicode array, passes tem to the encode_char method, 
  #transforms them to character, then join them.
  holder = array.map { |char_uni| (encode_char(lan, char_uni, key)).chr(Encoding::UTF_8) }
  holder.join

end

def encrypt(lan, text, key)

  #Vowel's tildes are erased, the string is stored as a unicode array, then
  #passed to array_operator
  array_operator(lan, to_unicode_array(normalize_text(text)), key)

end

def validate_language(input)

  #input validation
  if input != "1" && input != "2"

    puts "\nInvalid input, please Try Again. Select your language by typing in your option's number: \n\n1. Español\n2. English\n"
    validate_language(gets.chomp)

  #Spanish
  elsif input == "1"

    return CODEBASE_ES

  #English
  elsif input == "2"

    return CODEBASE_EN

  end

end

def validate_key(input)

  #Input validation
  if input.gsub(/\s+/, "").to_i.to_s == input

    return input.to_i

  else puts "Invalid input, please Try Again. \n\nPlease enter the encryption key, it may be any negative or positive integer\n"

    validate_key(gets.chomp)

  end

end

def validate_menu_option(lan, input)

  #Input validation
  if input != "1" && input != "2" && input != "3"

    puts "\nInvalid input, please Try Again. Do you wish to encrypt another text? \n\n1. Yes\n2. Change language\n3. Exit\n"
    validate_menu_option(lan, gets.chomp)

  #Retry without changing language
  elsif input == "1"

    main(lan)

  #Retry and change lanuage
  elsif input == "2"

    main

  #Exit
  elsif input == "3"

    puts "\nCome again soon!!!"

  end

end

def main(lan = nil)

  unless lan

    #CHEEEEEEEEEEEEEERS!!!!!!!!!
    puts "\nWelcome to your friendly neighbourhood Caesar's Cypherman!!!\n\n
    Please select your language: \n\n1. Español\n2. English\n"
    
    lan = validate_language(gets.chomp)

  end

  puts "\nLanguage selected: #{lan[:name]}\n\nPlease input the message you wish to encrypt: \n\n"

  #Fetching text
  text = gets.chomp

  puts "\n\nPlease enter the encryption key, it may be any negative or positive integer\n\n"

  #Fetching key
  key = validate_key(gets.chomp)

  puts "\n\nEncrypting text with key: #{key}\n\nEncrypted text:\n\n"

  #Ensambling
  puts encrypt(lan, text, key)

  puts "\n\nEncryption completed. Do you wish to have another go? \n\n1. Yes\n2. Change language\n3. Exit\n"

  #Final menu
  validate_menu_option(lan, gets.chomp)

end

#Run main method
main

#By Claudio Martínez Ortiz 14/08/2022 V1.0
