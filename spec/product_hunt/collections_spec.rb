require 'spec_helper'

describe "Collections API" do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  it 'implements collections#index and yields the newest collections' do
    stub_request(:get, "https://api.producthunt.com/v1/collections").
      to_return(lambda { |request|
        File.new("./spec/support/webmocks/collections_index.txt").read.
          gsub(/POST_TIMESTAMP/, (Time.now - 1 * 86400).strftime(TIMESTAMP_FORMAT))
      })

    collections = @client.collections
    expect(collections.size).to be > 0

    collection = collections.first
    created_at = collection.created_at

    expect(Time.now.to_date - created_at.to_date).to be <= 1 # either today's or yesterdays
  end

  describe 'by id' do

    before(:each) do
      stub_request(:get, "https://api.producthunt.com/v1/collections/1").
        to_return(File.new("./spec/support/webmocks/get_collection.txt"))

      @collection = @client.collection(1)
    end

    it 'implements collection#show and yields the name of the collection' do
      expect(@collection['name']).to eq('500 Startups: Demo Day')
      expect(@collection['id']).to eq(1)
    end

  end

end