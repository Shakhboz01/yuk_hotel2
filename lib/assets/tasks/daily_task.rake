namespace :daily_task do
  task send_message: :environment do
    puts 'Hello world!!!'
    SendMessage.run(message: 'Hello world')
  end
end
