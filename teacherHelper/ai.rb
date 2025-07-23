require 'cloudinary'

Cloudinary.config do |config|
  config.cloud_name = 'dpzp9ntw9'
  config.api_key = '825163774526164'
  config.api_secret = 'TJe1cvvTu3OijpA5X0XW8E97F44'
end

begin
  result = Cloudinary::Uploader.upload('Screenshot 2025-02-07 194709.png')
  puts "Upload successful! URL: #{result['secure_url']}"
rescue => e
  puts "Error: #{e.message}"
end