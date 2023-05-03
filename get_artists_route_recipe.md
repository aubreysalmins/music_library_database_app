Get /albums Route Design Recipe
Copy this design recipe template to test-drive a Sinatra route.

1. Design the Route Signature
You'll need to include:

the HTTP method
the path
any query parameters (passed in the URL)
or body parameters (passed in the request body)

Method: Get
Path: /artists

-

Method: Post
Path: /artists
Body parameters: name=Wild nothing, genre=Indie

Method: Get 
Path: /artists

2. Design the Response

Expected response: 200 OK
Pixies, ABBA, Taylor Swift, Nina Simone
-

Expected response: 200 OK (No content)

Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing

3. Write Examples

# Request:

GET /artists?

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone

-

# Request:

POST /artists?

# With body parameters:
name=Wild nothing
genre=Indie

# Expected response (200 OK)
No content

-

# Request:

GET /artists?

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone, Wild Nothing


4. Encode as Tests Examples
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /artists" do
    it 'should return a list of artists' do

      response = get('/artists')
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone')
    end
  end

  context "POST /artists" do
    it "creates a new artist" do
      response = post('/artists'name:'Wild nothing,genre:'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing')
    end
  end
end
5. Implement the Route
Write the route and web server code to implement the route behaviour.