#!/home/simbed/.rbenv/shims/ruby

# get the shebang line from $which ruby
# make this file executable with  $chmod +x octopus_spike_warn.rb
# dont include the ruby command in the chron (just the full file path)
# for environment variables to pass, add the profile in the chron
# . ~/.profile && /home/simbed/environment/Ruby/cronjobs/octopus_spike_warn.rb

require_relative 'octopus.rb'

octopus = Octopus.new(OCTOPUS_SECRETS, TWILIO_SECRETS).alert