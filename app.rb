require 'rubygems'
require 'sinatra'
require 'haml'
#require 'rdiscount' # in order to render markdown

=begin
#require 'data_mapper'
#require 'rpeg-multimarkdown'
#require 'parseconfig'


# Pull in config variables
config = ParseConfig.new('./simple-sinatra.config')
db_adapter = config.params['db_adapter']
db_host = config.params['db_host']
db_user = config.params['db_user']
db_password = config.params['db_password']
db_name = config.params['db_name']

# Wordpress DB setup

DataMapper.setup(:default, "#{db_adapter}://#{db_user}:#{db_password}@#{db_host}/#{db_name}")

# Register :multimarkdown template
#Tilt.register :multimarkdown, MultiMarkdown
#helpers do
#   def multimarkdown(*args) render(:multimarkdown, *args) end
#end

# MODEL 

class Post
	include DataMapper::Resource
	storage_names[:default] = 'wp_posts'
	property :id, Serial, :field => 'ID'
	property :title, Text, :field => 'post_title'
	property :content, Text, :field => 'post_content'
	property :date, DateTime, :field => 'post_date'
	property :status, String, :field => 'post_status'
	property :url, String, :field => 'guid'
	def self.recent
		#all(:id.gt => 2550, :order => [ :id.desc ])
		all(:limit => 20, :order => [ :id.desc ])		
	end
	def self.published
		all(:status => 'publish')
	end
	
end

# automatically create the post table
#Post.auto_migrate! unless Post.storage_exists?
=end
# VIEW

set :haml, :format => :html5
# set :haml, :locals => {:person_name => config.params['person_name']}
# Use views/layout.haml to render markdown pages.
#set :markdown, :layout_engine => :haml, :layout => :layout
set :erb, :layout_engine => :haml, :layout => :layout


get '/?' do
        nav = ["", "", ""]
        erb :index, :locals => {:nav => nav}
end

get '/indexx/?' do
        nav = ["", "", ""]
        markdown :index, :locals => {:nav => nav}
end

#get '/oldindex' do
#	File.read(File.join('public','index.html'))
#end

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

get '/posts' do
	#@posts = Post.all(:limit => 20)
	published = Post.published
	recent = published.recent
	#@posts = recent
	@posts = Post.recent.published
	if @posts
		erb :posts
	else
		#redirect '/indexx'
		'ups'
	end
end

get '/posts/:id' do
	@post = Post.get(params[:id])
	if @post
		erb :posts
	else
		redirect '/indexx'
	end
end


error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
end



