require 'spec_helper'

describe 'GET /posts' do
  it 'responds 200 OK' do
    get '/posts'
    @status = 200
  end

  it 'returns a list of posts' do
    create :post

    get '/posts'
    @schema =
      { posts:
        [ { content: String,
            longitude: Numeric,
            latitude: Numeric,
            created_at: Numeric
          }
        ]
      }
  end
end

describe 'POST /posts' do
  it 'responds 201 Created' do
    post '/posts', {post: {content: "hi"}}
    expect(response.status).to eq 201
  end

  it 'persists the given message' do
    post '/posts', {post: {content: "hi"}}
    get '/posts'
    expect(response_body['posts'][0]['content']).to eq 'hi'
  end
end
