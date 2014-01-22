require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5
set :erb, :layout_engine => :haml, :layout => :layout

def nav_array(index = 0)
  (1..3).map{|i| i == index ? "lifted" : ""}
end

get '/?' do
  haml :index, :locals => {:nav => nav_array}
end

get '/about' do
  subheads = ["bio", "name"]
  showmes = Hash.new
  anchors = Hash.new
  for subhead in subheads
    showmes[subhead] = ""
    anchors[subhead] = "about/#{subhead}/"
  end
  haml :about, :locals => {:nav => nav_array(1), :showmes => showmes, :anchors => anchors}
end

get '/about/*' do
  # Add this if block
  if params[:splat].first.empty?
    redirect '/about'
  end
  if /-/.match(params[:splat].first)
    path = params[:splat].first
    /-[a-z]*/ =~ path
    parttohide = Regexp.last_match(0).gsub(/-/, '') 
    path = path.gsub(/-([a-z]*)\//i, '')
    path = path.gsub(parttohide, '')
    path = path.gsub(/^/, '/about/')
    path = path.gsub('//', '/')
    redirect path
  else
    topics = params[:splat].first.split("/")
    subheads = ["bio", "name"]
    showmes = Hash.new
    anchors = Hash.new
    for subhead in subheads
      if topics.index(subhead)
        showmes[subhead] = "display: block;"
        anchors[subhead] = "-#{subhead}/"
      else
        showmes[subhead] = ""
        anchors[subhead] = "#{subhead}/"
      end
    end 
    haml :about, :locals => {:nav => nav_array(1), :showmes => showmes, :anchors => anchors}
  end
end

get '/contact/?' do
  erb :contact, :locals => {:nav => nav_array(3)}
end

get '/academics' do
  subheads = ["dissertation", "otherinterests", "publishing", "teaching", "tinkering", "tools", "poparticles", "presentations", "selfpublishing", "cartography"]
  showmes = Hash.new
  anchors = Hash.new
  for subhead in subheads
    showmes[subhead] = ""
    anchors[subhead] = "academics/#{subhead}/"
  end
  haml :academics, :locals => {:nav => nav_array(2), :showmes => showmes, :anchors => anchors}
end

get '/academics/*' do
  if /(poparticles|presentations|selfpublishing|cartography)/.match(params[:splat].first) 
    redirect params[:splat].first.gsub(/^/, '/academics/publishing/') unless /(\/publishing|^publishing)/.match(params[:splat].first)
  end
  if /-/.match(params[:splat].first)
    path = params[:splat].first
    if /-publishing/.match(path)
      path = path.gsub(/(poparticles|presentations|selfpublishing|cartography)\//, '')
    end
    /-[a-z]*/ =~ path
    parttohide = Regexp.last_match(0).gsub(/-/, '') 
    path = path.gsub(/-([a-z]*)\//i, '')
    path = path.gsub(parttohide, '')
    path = path.gsub(/^/, '/academics/')
    path = path.gsub('//', '/')
    redirect path
  else
    topics = params[:splat].first.split("/")
    subheads = ["dissertation", "otherinterests", "publishing", "teaching", "tinkering", "tools", "poparticles", "presentations", "selfpublishing", "cartography"]
    showmes = Hash.new
    anchors = Hash.new
    for subhead in subheads
      if topics.index(subhead)
        showmes[subhead] = "display: block;"
        anchors[subhead] = "-#{subhead}/"
      else
        showmes[subhead] = ""
        anchors[subhead] = "#{subhead}/"
      end
    end 
    haml :academics, :locals => {:nav => nav_array(2), :showmes => showmes, :anchors => anchors}
  end
end

error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end



