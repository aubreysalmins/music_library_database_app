require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'should validate album parameters' do
      response = post(
        '/albums',
        invalid_artist_title: 'OK Computer',
        another_invalid_thing: 123
      )

      expect(response.status).to eq(400)
    end

    it 'returns 200 OK' do
      response = post(
        '/albums',
        title:'Voyage',
        release_year:"2022",
        artist_id:"2"
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

  context "POST /artists" do
    it "creates a new artist" do

      response = post('/artists',name:'Wild nothing',genre:'Indie')
      repo = ArtistRepository.new
      artist = Artist.new

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('<a href="/artists/6">Wild nothing</a><br />')
    end
  end

  context "GET /albums/:id" do
    it "returns the first albums information" do
      response = get('/albums/1')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('Doolittle', 'Release year: 1989', 'Artist: Pixies')
    end
  end

  context "GET /artists/:id" do
    it 'should return the first artists information' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies', 'Rock')
    end
  end

  context "GET /albums" do
    it "returns a list of albums as an HTML page" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')
      expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')
      expect(response.body).to include('<a href="/albums/4">Super Trouper</a><br />')
      expect(response.body).to include('<a href="/albums/5">Bossanova</a><br />')
    end
  end

  context "GET /artists" do
    it "returns a list of artists as an HTML page" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a><br />')
      expect(response.body).to include('<a href="/artists/2">ABBA</a><br />')
    end
  end

  context 'GET /albums/new' do
    it 'should return the form to add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context 'GET /artists/new' do
    it 'should return the form to add a new artist' do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end
end
