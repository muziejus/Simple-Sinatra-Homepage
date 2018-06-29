require 'sinatra/base'
require 'haml'
require 'slim'
require 'sprockets'

class App < Sinatra::Base
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
    slim :index, layout: :bootstrap_layout, locals: { 
      hello: markdown(File.read("views/hello.md")),
      bio: markdown(File.read("views/bio.md")),
      contact: markdown(File.read("views/contact.md")),
      teaching: markdown(File.read("views/teaching.md")),
      research: markdown(File.read("views/research.md")),
      footer: markdown(File.read("views/footer.md"))
    }
  end

  get '/?' do
    haml :index, :locals => { :nav => nav_array }
  end

  get '/talks/mla-15-geocritical-explorations-inside-the-text' do
    haml :mla_15_geocritical, :layout => :layout_mla, :locals => { :nav  => nav_array(2), :subheads => subhead_hash(%w(bios abstracts proposal /talks/mla-15-geocritical-explorations-inside-the-text), []) }
  end

  get '/talks/mla-15-geocritical-explorations-inside-the-text/*' do
    # Add this if block
    if params[:splat].first.empty?
      redirect '/talks/mla-15-geocritical-explorations-inside-the-text'
    end
    if /-/.match(params[:splat].first)
      path = params[:splat].first
      /-[a-z]*/ =~ path
      parttohide = Regexp.last_match(0).gsub(/-/, '')
      path = path.gsub(/-([a-z]*)\//i, '')
      path = path.gsub(parttohide, '')
      path = path.gsub(/^/, '/talks/mla-15-geocritical-explorations-inside-the-text/')
      path = path.gsub('//', '/')
      redirect path
    else
      haml :mla_15_geocritical, :layout => :layout_mla, :locals => { :nav  => nav_array(2), :subheads => subhead_hash(%w(bios abstracts proposal), params[:splat].first.split("/")) }
    end
  end

  get '/talks/mla-15-geocritical-explorations-inside-the-text-beta' do
    redirect '/talks/mla-15-geocritical-explorations-inside-the-text'
  end

  get '/talks/mla15s344/?' do
    redirect '/talks/mla-15-geocritical-explorations-inside-the-text'
  end

  get '/talks/mla-15-geocritical-explorations-inside-the-text-beta/*' do
    redirect '/talks/mla-15-geocritical-explorations-inside-the-text'
  end

  get '/courses-nyu/map-city-novel-2016/?' do
    slim :map_city_novel_index
  end

  get '/courses-nyu/does-it-work/?' do
    slim :does_it_work_index, layout: :layout_diw
  end

  get '/courses-nyu/english-101-2017/?' do
    redirect 'https://muziejus.github.io/english-101-2017/syllabus.html'
  end

  get '/courses-nyu/english-101-2017/syllabus.pdf' do
    redirect 'https://muziejus.github.io/english-101-2017/syllabus.pdf'
  end

  get '/courses-nyu/english-101-2017a/?' do
    redirect 'https://muziejus.github.io/english-101-2017a/'
  end

  get '/courses-nyu/english-101-2017a/syllabus.pdf' do
    redirect 'https://muziejus.github.io/english-101-2017a/syllabus.pdf'
  end

  get '/courses-nyu/novel-maps-of-ny-2017/?' do
    redirect 'https://muziejus.github.io/novel-maps-of-ny-2017/'
  end

  get '/courses-nyu/novel-maps-of-ny-2017/syllabus.pdf' do
    redirect 'https://muziejus.github.io/novel-maps-of-ny-2017/syllabus.pdf'
  end

  get '/courses-nyu/media-history-of-nyc/?' do
    redirect 'https://muziejus.github.io/media-history-of-nyc/'
  end

  get '/courses-nyu/media-history-of-nyc/syllabus.pdf' do
    redirect 'https://muziejus.github.io/media-history-of-nyc/syllabus.pdf'
  end

  get '/wandering-rocks/?' do
    redirect 'http://muziejus.github.io/wandering-rocks/'
  end

  get '/dmfjsn-files.zip' do
    redirect 'https://muziejus.github.io/digital-mapping-for-javascript-novices/files/files.zip'
  end

  not_found do
    if request.path =~ /talks.*\/$/
      redirect request.path + 'index.html'
    else
      'Sinatra is giving a 404.<br>
      
      Try adding or removing a trailing slash (the “/” at the end of the URL)'
    end
  end

  get '/courses/presentation-tips/?' do
    slim "", layout: :bootstrap_naked, locals: {
      title: "Tips for giving a good presentation",
      content: markdown(File.read("views/presentation_tips.md"))
    }
  end

  error do
      'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end

end


