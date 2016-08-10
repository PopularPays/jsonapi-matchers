# Jsonapi::Matchers

A gem for testing the presence of specific resources in a json api response. Checking the schema is important like in [thoughtbot's json_matchers](https://github.com/thoughtbot/json_matchers). But you are still missing an assertion that the correct record was actually returned. This gem does just that!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-matchers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi-matchers

## Usage

#### For ensuring correct records are in the response

```
expect(response).to include(record)
```

```
RSpec.describe BooksController do
  include Jsonapi::Matchers::Response

  let(:book) { create(:book) }

  before do
    get :show, id: book.id
  end

  it "responds with the correct book" do
    expect(response).to include(book)
  end
end
```

`Note: Works for responses where data is an array or an object`


#### Supports checking the `included` resources

```
expect(response).to include(record).in(:included)
```

```
RSpec.describe BooksController do
  include Jsonapi::Matchers::Response

  let(:author) { create(:author) }
  let!(:book1) { create(:book, author: author) }
  let!(:book2) { create(:book, author: author) }

  before do
    get :index
  end

  it "includes the author" do
    expect(response).to include(author).in(:included)
  end

  it "includes the correct books" do
    expect(response).to include(book1)
    expect(response).to include(book2)
  end
end
```
