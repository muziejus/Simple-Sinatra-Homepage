require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5
set :erb, :layout_engine => :haml, :layout => :layout

def nav_array(index = 0)
  (1..3).map{|i| i == index ? "lifted" : ""}
end

def subhead_hash(subheads, topics = [], path = "")
  Hash[
    subheads.map do |subhead|
      if topics.index(subhead)
        [subhead, { :showme => "display: block", :anchor => "-#{subhead}/" }]
      else
        [subhead, { :showme => "", :anchor => "#{path}#{subhead}/" }]
      end
    end
  ]
end

get '/?' do
  haml :index, :locals => { :nav => nav_array }
end

get '/about' do
  haml :about, :locals => { :nav => nav_array(1), :subheads => subhead_hash(["bio", "name"], [], "about/") }
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
    haml :about, :locals => { :nav => nav_array(1), :subheads => subhead_hash(["bio", "name"], params[:splat].first.split("/")) }
  end
end

get '/contact/?' do
  erb :contact, :locals => { :nav => nav_array(3) }
end

get '/academics' do
  haml :academics, :locals => { :nav => nav_array(2), :subheads => subhead_hash(["dissertation", "otherinterests", "publishing", "teaching", "tinkering", "tools", "poparticles", "presentations", "selfpublishing", "cartography"], [], "academics/") }
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
    haml :academics, :locals => { :nav => nav_array(2), :subheads => subhead_hash(["dissertation", "otherinterests", "publishing", "teaching", "tinkering", "tools", "poparticles", "presentations", "selfpublishing", "cartography"], params[:splat].first.split("/")) }
  end
end

get '/calendar' do
  haml :calendar, :locals => { :nav => nav_array }
end

get '/talks/mla-15-geocritical-explorations-inside-the-text' do
  redirect "http://moacir.com/donkeyhottie/2014/03/01/geocritical-explorations-within-the-text/"
end

not_found do
  'Sinatra is giving a 404.'
end

error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end



