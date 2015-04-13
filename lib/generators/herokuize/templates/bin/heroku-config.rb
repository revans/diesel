#!/usr/bin/env ruby
require 'pathname'

# write message and perform action if user says yes
def message(msg, &block)
  puts "--> #{msg} (yes/no)"
  answer = gets.chomp

  if answer =~ /y/i || answer =~ /yes/i
    yield if block_given?
  end
end


message "Do you want to install Redis Cloud for background processing?" do
  system 'heroku addons:add rediscloud'
end

message "Do you want to install Memecache for caching?" do
  system 'heroku addons:add memcachedcloud'
end

message "Do you want to install Rollbar for exception tracking?" do
  system 'heroku addons:add rollbar'
end

message "Do you want to install Papertrail for central app logging?" do
  system 'heroku addons:add papertrail'
end

message "Do you want to install NewRelic for metric monitoring?" do
  system 'heroku addons:add newrelic'
end

message "Do you want to install Zero Push for Push notifications" do
  system 'heroku addons:add zeropush'
end

message "Do you want to install Mandrill for Email Service?" do
  system 'heroku addons:add mandrill'
end

message "Do you want to install Codeship for Continuous Integration Server?" do
  system 'heroku addons:add codeship'
end

message "Do you want to install Cloudinary for File/Image uploading?" do
  system 'heroku addons:add cloudinary'
end
