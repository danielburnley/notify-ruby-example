require 'dotenv/load'
require 'pry'
require 'notifications/client'

api_key = ENV['API_KEY']
template_id = ENV['TEMPLATE_ID']
email_address = ENV['SEND_TO']

client = Notifications::Client.new(api_key)

answers = {
  "About you": {
    "Surname": "Meowington",
    "First name(s) (in full)": "Cat",
    "Your address (where you are registered to vote)": "123 Fake street, Fake Town, Fake County, FA12 1KE",
    "Phone number (optional)": "12345678901",
    "Email (optional)": "fake@example.com"
  },
  "How long do you want a postal vote for": {
    "Length of time": "For the period",
    "From": "12/12/2021",
    "To": "6/6/2022"
  },
  "Address for the ballot paper": {
    "Please send my ballot paper to": "123 Fake street, Fake Town, Fake County, FA12 1KE",
    "The reason I would like my ballot paper sent to this address": "Some reason or other"
  },
  "Your date of birth and declaration": {
    "Date of birth": "01/01/1990",
    "Signature(?)": "Yes"
  },
  "Date of application": {
    "Today's date": "15/12/2021"
  }
}

short_answers = {
  "About you": {
    "Surname": "Meowington",
    "First name(s) (in full)": "Cat",
    "Your address (where you are registered to vote)": "123 Fake street, Fake Town, Fake County, FA12 1KE",
    "Phone number (optional)": "12345678901",
    "Email (optional)": "fake@example.com"
  }
}

def v1(answers)
  answers.map do |page, questions|
    question_text = questions.map do |question, answer|
      "* #{question}: #{answer}\r\n"
    end.join("\r\n")

    "#{page}\r\n#{question_text}"
  end.join("\r\n")
end

def v2(answers)
  answers.map do |page, questions|
    question_text = questions.map do |question, answer|
      "* #{question}\r\n\r\n#{answer}\r\n"
    end.join("\r\n")

    "# #{page}\r\n#{question_text}"
  end.join("\r\n")
end

def v3(answers)
  answers.map do |page, questions|
    question_text = questions.map do |question, answer|
      "* #{question}\r\n#{answer}\r\n"
    end.join("\r\n")

    "# #{page}\r\n#{question_text}"
  end.join("\r\n")
end

def v4(answers)
  answers.map do |page, questions|
    question_text = questions.map do |question, answer|
      "  * #{question}\r\n#{answer}\r\n"
    end.join("\r\n")

    "* #{page}\r\n#{question_text}"
  end.join("\r\n")
end

all_together = [
  v1(short_answers),
  v2(short_answers),
  v3(short_answers),
  v4(short_answers)
]

# response = client.send_email(
#   email_address: email_address,
#   template_id: template_id,
#   personalisation: {
#     answers: all_together.join("\r\n---\r\n")
#   }
# )

response = client.send_email(
   email_address: email_address,
   template_id: template_id,
   personalisation: {
     personal: "Some information",
     subject: "adshasjkd"
   },
   reference: "123ABC"
)

puts "Raw text:"
puts "V1:"
puts
puts all_together[0]
puts

puts "V2:"
puts
puts all_together[1]
puts
puts "V3:"
puts
puts all_together[2]
puts
puts "V4:"
puts
puts all_together[3]
puts

puts "Notify response ID"
puts response
binding.pry
