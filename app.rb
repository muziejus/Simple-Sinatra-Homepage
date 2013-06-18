require 'rubygems'
require 'sinatra'
require 'haml'

set :haml, :format => :html5
set :erb, :layout_engine => :haml, :layout => :layout


get '/?' do
        nav = ["", "", ""]
        erb :index, :locals => {:nav => nav}
end

get '/about' do
	subheads = ["bio", "name"]
	nav = ["lifted", "", ""]
	showmes = Hash.new
	anchors = Hash.new
	for subhead in subheads
		showmes[subhead] = ""
		anchors[subhead] = "about/#{subhead}/"
	end
	erb :about, :locals => {:nav => nav, :showmes => showmes, :anchors => anchors}
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
		nav = ["lifted", "", ""]
		showmes = Hash.new
		anchors = Hash.new
		for subhead in subheads
			if topics.index(subhead)
				showmes[subhead] = "style='display: block;'"
				anchors[subhead] = "-#{subhead}/"
			else
				showmes[subhead] = ""
				anchors[subhead] = "#{subhead}/"
			end
		end	
		erb :about, :locals => {:nav => nav, :showmes => showmes, :anchors => anchors}
	end
end

get '/contact/?' do
	nav = ["", "", "lifted"]
	erb :contact, :locals => {:nav => nav}
end

get '/academics' do
	subheads = ["dissertation", "otherinterests", "publishing", "teaching", "tinkering", "tools", "poparticles", "presentations", "selfpublishing", "cartography"]
	nav = ["", "lifted", ""]
	showmes = Hash.new
	anchors = Hash.new
	for subhead in subheads
		showmes[subhead] = ""
		anchors[subhead] = "academics/#{subhead}/"
	end
	erb :academics, :locals => {:nav => nav, :showmes => showmes, :anchors => anchors}
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
		nav = ["", "lifted", ""]
		showmes = Hash.new
		anchors = Hash.new
		for subhead in subheads
			if topics.index(subhead)
				showmes[subhead] = "style='display: block;'"
				anchors[subhead] = "-#{subhead}/"
			else
				showmes[subhead] = ""
				anchors[subhead] = "#{subhead}/"
			end
		end	
		erb :academics, :locals => {:nav => nav, :showmes => showmes, :anchors => anchors}
	end
end

error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end



