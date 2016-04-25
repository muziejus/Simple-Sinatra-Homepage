# encoding: utf-8
require 'pony'
require 'data_mapper'

class App

  get '/is40' do
    haml :is40, :locals => { :nav => nav_array }
  end

  post '/is40' do
    body = email_40_party_body(params)
    attachments = email_40_party_attachments(params)
    [:cocktails, :dinner, :drinks].each do |event|
      params[event] == "on" ? params[event] = true : params[event] = false
    end
    unless params[:regrets] == "on"
      Guest.create(name: params[:name], email: params[:email], numbers: params[:guest_num], cocktails: params[:cocktails], dinner: params[:dinner], drinks: params[:drinks], comment: params[:note], added_on: Time.now)
    end
    Pony.mail(
      to: "#{params[:email]}, moacir@moacir.com",
      from: "moacir.is.40.bot@gmail.com",
      # this requires going to the user security page and enabling "low-security" apps at the bottom
      via: :smtp,
      via_options: {
        user_name: "moacir.is.40.bot@gmail.com",
        password: "kyle-alliance-bred-assign",
        address: "smtp.gmail.com",
        port: '587', enable_starttls_auto: true,
        authentication: :plain, domain: 'localhost.localdomain'
      },
      subject: "[Moacir Is 40] Confirmation of #{params[:name]}’s RSVP",
      attachments: attachments,
      body: body
    )
    haml :is40_thanks, :locals => { :nav => nav_array }
  end

  get "/is40/solet'sparty" do
    @guests = Guest.all
    haml :is40_list, :locals => { :nav => nav_array, guests: Guest.all }
  end

  def email_40_party_body(params)
    body = "Dear #{params[:name]},\n\n"
    if params[:regrets] 
      body << "Sorry you won’t be attending this event.\n"
    else
      params[:guest_num] == "1" ? guest_txt = "1 guest" : guest_txt = "#{params[:guest_num]} guests"
      body << "Thank you for RSVPing to the party. As a reminder, the date is Saturday, 7 May 2016.\n\nYou can follow your (and everyone else’s RSVPs) here: http://moacir.com/is40/solet'sparty\n\nYou have RSVPed for #{guest_txt} for the following events:\n\n"
      if params[:cocktails]
        body << "* 16:00: Cocktails at Moacir’s (14 Washington Pl, 4E)\n"
      end
      if params[:dinner]
        body << "* 19:00: Dinner at Brick Lane Curry House (99 2nd Ave, by 6th)\n"
      end
      if params[:drinks]
        body << "* 22:00: Drinks at Ace Bar (531 E. 5th, btwn A & B)\n"
      end
      body << "\n"
      if params[:dinner]
        body << "NOTE: Dinner is first-come first-served to these RSVPs. As a result, we can only confirm room for you in the near future.\n"
      end
    end
    if params[:note]
      body << "\nThank you for your note:\n\n#{params[:note]}\n"
    end
    body << "\nCheers,\nA Robot.\n\nPS: You can always call Moacir at +1 312 492 8828 for more information.\n"
  end

  def email_40_party_attachments(params)
    attachments = {}
    if params[:cocktails]
      attachments["cocktails.ics"] = File.read("./cocktails.ics")
    end
    if params[:dinner]
      attachments["dinner.ics"] = File.read("./dinner.ics")
    end
    if params[:drinks]
      attachments["drinks.ics"] = File.read("./drinks.ics")
    end
    attachments unless params[:regrets]
  end
end

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/bday.sqlite")

class Guest
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :numbers, Integer
  property :cocktails, Boolean
  property :dinner, Boolean
  property :drinks, Boolean
  property :comment, Text
  property :added_on, Date

  def short_name
    self.name.gsub(/ (.).*/, ' \1.')
  end

end

DataMapper::Model.raise_on_save_failure = true
DataMapper.finalize
# DataMapper.auto_migrate!
DataMapper.auto_upgrade!

