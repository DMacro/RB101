# the loan amount
# the Annual Percentage Rate (APR)
# the loan duration
# need to validate number (must be intergers or floats and must be positive)
# Ask is this is required again.

# OTHER SOURCES

require_relative "text_format.rb"

# METHODS

def prompt(message)
  format_type("=> #{message}", '', 'clear')
end

def question_prompt(message)
  format_type("=> #{message}", '', 'yellow')
end

def warning_prompt(message)
  format_type("=> #{message}", '', 'red')
end

def information_prompt(message)
  format_type("=> #{message}", '', 'light_blue')
end

def important_prompt(message)
  format_type("=> #{message}", '', 'bold')
end

def calc_prompt(message)
  format_type("=> #{message}", '', 'green')
end

def valid_integer?(value)
  value.to_i.to_s == value
end

def valid_float?(value)
  value.to_f.to_s == value
end

def valid?(value)
  valid_float?(value) || valid_integer?(value)
end

def valid_loan_value?(value)
  valid?(value) && (value.to_f >= MIN_LOAN) && (value.to_f <= MAX_LOAN)
end

def valid_interest_rate?(value)
  valid?(value) && (value.to_f >= MIN_APR) && (value.to_f <= MAX_APR)
end

def valid_payback_term?(value)
  valid?(value) && (value.to_f >= MIN_TERM) && (value.to_f <= MAX_TERM)
end

def whole_number_currency(number)
  number.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

def decimal_number_currency(number)
  if number.length == 2
    number
  else
    number += '0'
  end
end

def number_format(number)
  number = number.round(2)

  arrayed_number = number.to_s.split(/[\.]/)

  whole_number = whole_number_currency(arrayed_number[0])
  decimal_number = decimal_number_currency(arrayed_number[1])

  whole_number + '.' + decimal_number
end

def years_to_months(years)
  years.to_f * 12
end

def interest_convert(annual_rate)
  annual_rate.to_f.round(2) / 1200
end

def loan_convert(loan_value)
  loan_value.to_f.round(2)
end

def repayments(val, ir, loan_months)
  # p = loan amount; j = monthly interest rate; n = loan duration in months
  val * (ir / (1 - (1 + ir)**(-loan_months))) # monthly repayment
end

def currency_symbol(currency)
  currency = currency.to_sym
  CURRENCY_ABBREVIATED[currency]
end

# VARIABLES AND CONSTANTS

CURRENCY_ABBREVIATED = {
  EURO: '€',
  USD: '$',
  GBP: '£'
}

CURRENCY_CHOICES = CURRENCY_ABBREVIATED.keys.join(', ')

currency_choice = ''
borrowed = '' # loan amount
apr = '' # annual interest rate
timeframe_years = '' # years
S_1 = 0.5
S_2 = 0.75
S_3 = 1.0
S_4 = 1.25
MIN_TERM = 3
MAX_TERM = 40
MIN_APR = 5
MAX_APR = 15
MIN_LOAN = 1000
MAX_LOAN = 1000000

# CODE

question_prompt('Welcome to the loan calculator. Please enter your name?')

name = gets.chomp()

prompt("Hello #{name}. My name is MALCAL. I am an automated bankbot.")
sleep(S_4)
prompt('I am here to assist you in your application today.')
sleep(S_4)
prompt('I will require the following pieces of information:')
sleep(S_4)

information = <<~MSG

  =>  1. Currency to borrow in - Euro(€), USD($) or GBP(£).
  =>  2. Value you wish to borrow - between 1,000 and 1,000,000.
  =>  3. Annual Percentage Rate - between 5% and 15%.
  =>  4. The Payback duration - between 3 and 40 years.
MSG

important_prompt(information)

loop do
  question_prompt("Please select currency: #{CURRENCY_CHOICES}")
  currency_select = gets.chomp.upcase
  if CURRENCY_CHOICES.upcase.include?(currency_select)
    currency_choice = currency_symbol(currency_select)
    break
  else
    warning_prompt("Please enter currency #{CURRENCY_CHOICES}")
  end
end

loop do
  loop do
    loop do
      question_prompt("LOAN VALUE: please enter value in (#{currency_choice}).")
      borrowed = gets.chomp
      if valid_loan_value?(borrowed)
        break
      elsif warning_prompt('Please entered correct value (1,000 - 1,000,000)')
      end
    end

    loop do
      question_prompt("INTEREST RATE: please enter the APR. Expect to pay 9%")
      apr = gets.chomp
      if valid_interest_rate?(apr)
        break
      elsif warning_prompt('Please entered correct value (5-15)')
      end
    end

    loop do
      question_prompt("TIMEFRAME: please enter payback period in years)")
      timeframe_years = gets.chomp

      if valid_payback_term?(timeframe_years)
        break
      elsif warning_prompt('You have not entered a correct value! (3-40)')
        warning_prompt('Please enter a valid figure (i.e 2.5, 3, etc.)')
      end
    end

    loan_value = number_format(borrowed.to_f)

    prompt("Great #{name}! So just to recap you are looking to borrow:")
    information_prompt("#{currency_choice}#{loan_value}")
    prompt('At an interest rate of:')
    information_prompt("#{apr.to_f}%")
    prompt('Over a period of:')
    information_prompt("#{timeframe_years.to_f} years")

    question_prompt("Do you want to change any figures? (y/n)")
    change = gets.chomp.downcase
    if change.start_with?('y')
    else
      break
    end
  end
  
  sleep(S_4)

  time_months = years_to_months(timeframe_years)
  interest = interest_convert(apr)
  loan = loan_convert(borrowed)

  monthly_payments = repayments(loan, interest, time_months)
  monthly_payments_format = number_format(monthly_payments)

  total_repayments = monthly_payments * time_months
  total_repayments_format = number_format(total_repayments)

  interest_paid = total_repayments - loan
  interest_paid_format = number_format(interest_paid)

  important_prompt('Monthly repayment:')
  calc_prompt("#{currency_choice}#{monthly_payments_format}")
  important_prompt('Payback Period:')
  calc_prompt("#{time_months} months.")
  important_prompt('Total payback of:')
  calc_prompt("#{currency_choice}#{total_repayments_format}")
  important_prompt('Interest payable on loan:')
  calc_prompt("#{currency_choice}#{interest_paid_format}")
  sleep(0.5)

  question_prompt("Would you like to do another calculation? (y/n)")

  reapply = gets.chomp.downcase
  if reapply.start_with?('y')
  else
    break
  end
end

prompt("Thank you #{name}, for your time.")
sleep(S_2)
prompt('I hope this has been helpful for you.')
sleep(S_1)
prompt('Best of luck with your future finances.')
