require 'spec_helper'

get '/posts' do
  given post: { message: 'Cats!' } do
    get '/posts', {q: 'cat'} do
      response 200
      body schema:
    end
  end


  response 200
  body schema:
    { posts:
      [ { message:    String
          upvotes:    Numeric
          created_at: /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\dZ$/
        }
      ]
    }

  retrieves :post

  request query:
    { q: 'cats' }

  retrieves :post, message: 'Cats!'
  does_not_retrieve :post, message: 'Dogs!'
end

# translates to:

describe 'GET /posts' do
  it 'responds with status 200' do
    get '/posts'
    expect(response.status).to eq 200
  end

  it 'responds with an array of posts' do # looks only at top-level keys and their datatypes to generate this message. another possible message: 'responds with an error and a message'
    get '/posts'
    expect(JSON response.body).to conform_to_schema #...
  end

  it 'retrieves a post' do
    post = FactoryGirl.create :post
    get '/posts'
    expect(JSON response.body).to contain_somewhere id: post.id # assuming the Post class defines identifying_attributes to return :id
  end

  context 'with query {q: "cats"}' do
    it 'retrieves a post with message "Cats!"' do
      post = FactoryGirl.create :post, message: "Cats!"
      get '/posts', {q: "cats"}
      expect(JSON response.body).to contain_somewhere id: post.id # will find by message instead if no identifying_attributes are defined
    end

    it 'does not retrive a post with message "Dogs!"' do
      post = FactoryGirl.create :post, message: "Dogs!"
      get '/posts', {q: "cats"}
      expect(JSON response.body).not_to contain_anywhere id: post.id # will find by message instead if no identifying_attributes are defined
    end
  end
end

describe 'GET /posts' do
  it 'responds 200 OK' do
    get '/posts'
    @status = 200
  end

  it 'returns a list of posts' do
    get '/posts'
    @schema = #TODO
  end
end

describe 'POST /posts' do
  it 'responds 201 Created' do
    post '/posts', {post: {message: "hi"}}
    expect(response.status).to eq 201
  end

  it 'persists the given message' do
    post '/posts', {post: {message: "hi"}}
    get '/posts'
    expect(JSON response.body).to eq({'posts' => [{"message" => "hi"}]})
  end
end
