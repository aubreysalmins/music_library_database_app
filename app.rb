# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    
    return erb(:albums)
  end

  post '/albums' do
    repo = AlbumRepository.new
    album = Album.new

    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo.create(album)

    return ''
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    # response = artists.map do |artist|
    #   artist.name
    # end.join(", ")

    return erb(:artist_links)
  end

  post '/artists' do
    repo = ArtistRepository.new
    artist = Artist.new

    artist.genre = params[:genre]
    artist.name = params[:name]
    repo.create(artist)

    return ''
  end

  get '/albums/:id' do
    @id = params[:id]

    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    album = repo.find(@id)
    
    @title = album.title
    @release_year = album.release_year
    @artist = artist_repo.find(album.artist_id).name
    
    return erb(:index)
  end

  get '/artists/:id' do
    @id = params[:id]

    repo = ArtistRepository.new
    artist = repo.find(@id)

    @name = artist.name
    @genre = artist.genre

    return erb(:artists)
  end 
end