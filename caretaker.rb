#!/usr/bin/env ruby
require_relative 'crinkle_butt'
require_relative 'language'

# A caretaker bot extension
module CareTaker
  include Language

  # Gets a hash of all babs this CareTaker is watching, associated to
  # their CrinkleButt objects
  def babs
    @babs = {} if @babs.nil?
    @babs
  end

  # Babysits a user, a bot-exposed function that creates a CrinkleButt
  # object for the user this is supposed to babysit
  def bot_babysit(event, user)
    user_id = user[/\d+/].to_i

    if babs.key? user_id
      event.respond "Awww, this #{bab_name} wants #{bab_attention}"
    else
      babs[user_id] = create_bab(event, user_id)
      event.respond "#{bab_ok.capitalize} lets get you all cleaned up"
    end
  end

  # Creates a CrinkleButt object for the passed in user and event that
  # called #bab_check in this module
  def create_bab(event, user_id)
    CrinkleButt.new(event, user_id) do |bab|
      bab_check(bab)
    end
  end

  # Checks the bab passed in, and notices if their diaper needs attention
  def bab_check(bab)
    return if bab.user.idle?
    return unless bab.diaper > 10

    bab.message bab_notice.capitalize
    sleep 3
    bab.ping_message bab_diaper_full
  end
end