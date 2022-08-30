# Copyright (c) 2022 Claudio Martínez Ortiz

# Languages supported
CODEBASE_ES = { name: 'Español', chars: 27,
                lower: [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 241, 111, 112, 113, 114,
                        115, 116, 117, 118, 119, 120, 121, 122],
                upper: [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 209, 79, 80, 81, 82, 83, 84, 85, 86,
                        87, 88, 89, 90] }.freeze

CODEBASE_EN = { name: 'English', chars: 26,
                lower: [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
                        116, 117, 118, 119, 120, 121, 122],
                upper: [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87,
                        88, 89, 90] }.freeze

def normalize_text(text)
  # Normalizes text by replacing common irregular spanish characters with analog
  text.gsub('á', 'a').gsub('é', 'e').gsub('í', 'i').gsub('ó', 'o').gsub('ú', 'u').gsub('Á', 'A').gsub('É', 'E')
      .gsub('Í', 'I').gsub('Ó', 'O').gsub('Ú', 'U')
end

def to_unicode_array(text)
  # Converts text's characters to their unicode values and stores them in an array
  holder = []
  text.each_codepoint { |char| holder << char }
  holder
end

def lower?(lan, char_uni)
  # Checks wether unicode number is in CODEBASE_LAN[:lower]
  lan[:lower].any? { |uni| char_uni == uni }
end

def upper?(lan, char_uni)
  # Checks wether unicode number is in CODEBASE_LAN[:upper]
  lan[:upper].any? { |uni| char_uni == uni }
end

def encode_char(lan, char_case, char_uni, key)
  # Iterate over language case and return new index encoded by key
  lan[char_case].each_with_index do |uni, idx|
    return lan[char_case][(idx + key) % lan[:chars]] if char_uni == uni
  end
end

def case_id(lan, char_uni, key)
  if lower?(lan, char_uni)

    encode_char(lan, :lower, char_uni, key)

  # Since it's not in [:lower], checks whether it's in [:upper]
  elsif upper?(lan, char_uni)

    encode_char(lan, :upper, char_uni, key)

  # Since it's neither in [:lower] nor [:upper], returns it unmodified
  else
    char_uni

  end
end

def array_operator(lan, array, key)
  # Iterates over the unicode array, passes them to the case_id method,
  # transforms them to character, then join them.
  holder = array.map { |char_uni| case_id(lan, char_uni, key).chr(Encoding::UTF_8) }
  holder.join
end

def encrypt(lan, text, key)
  # Vowel's tildes are erased, the string is stored as a unicode array, then
  # passed to array_operator
  array_operator(lan, to_unicode_array(normalize_text(text)), key)
end

def invalid_input_msg(lan = nil)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nOpción ingresada no válida. Por favor vuelve a intentarlo"

  when CODEBASE_EN

    puts "\nInvalid input, please try again"

  else
    puts "\nOpción ingresada no válida. Por favor vuelve a intentarlo
Invalid input, please try again"

  end
end

def welcome_msg(lan = nil)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nWena shoro!!! Bienvenido a Cypherlef!!!"

  when CODEBASE_EN

    puts "\nWelcome to your friendly neighbourhood Cypherlef!!!"

  else
    puts "\nWena shoro!!! Bienvenido a Cypherlef!!!
Welcome to your friendly neighbourhood Cypherlef!!!\n"

  end
end

def language_request_msg(lan = nil)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nPor favor elige tu lenguaje\n1. Español\n2. English\n"

  when CODEBASE_EN

    puts "\nPlease select your language\n1. Español\n2. English\n"

  else
    puts "\nPor favor elige tu lenguaje\nPlease select your language
1. Español\n2. English\n"

  end
end

def validate_language(input, lan = nil)
  # Input validation
  case input
  when '1'

    CODEBASE_ES

  when '2'

    CODEBASE_EN

  else

    again(lan, method(:language_request_msg), method(:validate_language))
    # invalid_input_msg(lan)
    # language_request_msg(lan)
    # validate_language(gets.chomp, lan)

  end
end

def language_selected_msg(lan)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nLenguaje seleccionado: Español"

  when CODEBASE_EN

    puts "\nLanguage selected: English"

  end
end

def text_request_msg(lan)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nPor favor ingresa el mensaje a encriptar:\n"

  when CODEBASE_EN

    puts "\nPlease input the message you wish to encrypt:\n"

  end
end

def key_request_msg(lan)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nIngresa la llave de encriptación, puede ser un entero negativo o positivo\n"

  when CODEBASE_EN

    puts "\nPlease enter the encryption key, it may be any negative or positive integer\n"

  end
end

def validate_key(lan, input)
  # Input validation
  if input.gsub(/\s+/, '').to_i.to_s == input

    input.to_i

  # Input request
  else
    again(lan, method(:key_request_msg), method(:validate_key))
    # invalid_input_msg(lan)
    # key_request_msg(lan)
    # validate_key(lan, gets.chomp)

  end
end

def encrypting_text_msg(lan, key)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nEcriptando el texto con llave: #{key}, por favor espera\n\n"

  when CODEBASE_EN

    puts "\nEncrypting text with key: #{key}, please wait\n\n"

  end
end

def final_msg(lan)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nEcriptación completa. Quieres encriptar otro texto?
\n1. Sí\n2. Cambiar lenguaje\n3. Salir\n"

  when CODEBASE_EN

    puts "\nEncryption completed. Do you wish to have another go?
\n1. Yes\n2. Change language\n3. Exit\n"

  end
end

def goodbye_msg(lan)
  # Message according to selected language
  case lan
  when CODEBASE_ES

    puts "\nVuelve pronto!!! <(^^<)"

  when CODEBASE_EN

    puts "\nCome again soon!!! <(^^<)"

  end
end

def change_language(lan)
  language_request_msg(lan)
  holder = validate_language(gets.chomp, lan)
  language_selected_msg(holder)
  main(holder)
end

def again(lan, message, validate)
  invalid_input_msg(lan)
  message.call(lan)
  validate.call(lan, gets.chomp)
end

def validate_menu_option(lan, input)
  case input
  when '1'

    main(lan)

  when '2'

    change_language(lan)

  when '3'

    goodbye_msg(lan)
    exit(0)

  else

    again(lan, method(:final_msg), method(:validate_menu_option))

  end
end

def welcome(lan = nil)
  if lan

  else
    # CHEEEEEEEEEEEEEERS!!!!!!!!!
    welcome_msg
    # Request language selection
    language_request_msg
    lan = validate_language(gets.chomp)
    language_selected_msg(lan)
    main(lan)
  end
end

def main(lan = nil)
  welcome(lan)
  text_request_msg(lan)

  # Fetching text
  text = gets.chomp

  key_request_msg(lan)

  # Fetching key
  key = validate_key(lan, gets.chomp)

  encrypting_text_msg(lan, key)

  # Ensambling
  puts encrypt(lan, text, key)

  final_msg(lan)
  # Final menu
  validate_menu_option(lan, gets.chomp)
end

# Run main method
main
# By Claudio Martínez Ortiz 14/08/2022 V1.01
