Get /albums Route Design Recipe
Copy this design recipe template to test-drive a Sinatra route.

1. Design the Route Signature
You'll need to include:

the HTTP method
the path
any query parameters (passed in the URL)
or body parameters (passed in the request body)

Method: Post
Path: /albums
Body parameters: title=Voyage, release_year=2022, artist_id=2

2. Design the Response
The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return 200 OK if the post exists, but 404 Not Found if the post is not found in the database.

Your response might return plain text, JSON, or HTML code.

Replace the below with your own design. Think of all the different possible responses your route will return.

Expected response: 200 OK (No content)

3. Write Examples
Replace these with your own design.

# Request:

POST /albums?

# With body parameters:
title=Voyage&
release_year=2022&
artist_id=2

# Expected response:

Response for 200 OK

4. Encode as Tests Examples
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /albums" do
    it 'returns 200 OK' do
      response = get('/posts?title=Voyage&release_year=2022&artist_id=2')
      repo = AlbumRepository.new
      album = Album.new
      album.title = params[:title]
      album.release_year = params[:release_year]
      album.artist_id = params[:artist_id]
      repo.create(album)

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end

end
5. Implement the Route
Write the route and web server code to implement the route behaviour.