COLOUR_CODE = {
  red: 31,
  green: 32,
  yellow: 33,
  blue: 34,
  pink: 35,
  light_blue: 36,
  bold: 1,
  black: 30,
  grey: 2,
  italic: 3,
  underline: 4,
  clear: 0
}

def format_code(type)
  type = type.to_sym
  COLOUR_CODE[type]
end

def format_type(text, type1='clear', type2='clear')
  code1 = format_code(type1)
  code2 = format_code(type2)
  puts "\e[#{code1};#{code2}m#{text}\e[0m"
end
