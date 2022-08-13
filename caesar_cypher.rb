CODEBASE_ES = [[97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 
  110, 241, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122], [65, 
  66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 209, 79, 80, 81, 82, 83,
  84, 85, 86, 87, 88, 89, 90]] # [[a, b, c, d, e, f, g, h, i, j, k, l, m, n, ñ,
  #o, p, q, r, s, t, u, v, w , x, y, z], [A, B, C, D, E, F, G, H, I, J, K, L,
  #M, N, Ñ, O, P, Q, R, S, T, U, V, W, X, Y, Z]], [[27 lower], [27 UPPER]]

CODEBASE_EN = [[97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 
  110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122], [65, 66, 
  67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85,
  86, 87, 88, 89, 90]] # [[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,
  #r, s, t, u, v, w , x, y, z], [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O,
  #P, Q, R, S, T, U, V, W, X, Y, Z]], [[26 lower], [26 UPPER]]

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

def encode_char(char_case, char_uni, key)

  #Locates unicode number in CODEBASE_LAN and offsets by key
  char_case.select.with_index do |uni, idx| char_uni == uni 

    if char_uni == uni
      
      return [char_case[idx + key]]
    
    end

  end

end

def encode_char?(char_case, char_uni, key) 

  # Checks if unicode number is in CODEBASE_LAN[char_case], returns false otherwise
  holder = encode_char(char_case, char_uni, key)
  
  if holder.empty? 
    
    return false
    
  else holder[0]

  end

end

def check_char(char_uni, key)
  
  CODEBASE_ES.each do |char_case|
       
    #Checks if unicode number is in CODEBASE_LAN

    unless char_case.none? { |uni| char_uni == uni }
      
      holder = encode_char?(char_case, char_uni, key)

      if holder

        return holder

      end

    else char_uni
      
      next

    end

  end

end

def array_operator(array, key)
  
  #Iterates over the unicode array, modifies values by key, transforms them to
  #character, then join them.
  holder = array.map { |char_uni| (check_char(char_uni, key)).chr(Encoding::UTF_8) }
  p holder.join

end

def encrypt(text, key)

  array_operator(to_unicode_array(normalize_text(text)), key)

end

str = ("La cabaña del tío Tom!")
encrypt(str, 1)