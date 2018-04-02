# Jsonapi::Matchers

A gem for testing the presence of specific resources/attributes in a json api response. Checking the schema is important like in [thoughtbot's json_matchers](https://github.com/thoughtbot/json_matchers). But you are still missing an assertion that the correct record was actually returned. This gem does just that!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-matchers', github: 'PopularPays/jsonapi-matchers'
```

And then execute:

    $ bundle

## Usage

#### Ensuring correct records are in the response

```ruby
expect(response).to have_record(record)
```

```ruby
RSpec.describe BooksController do
  include Jsonapi::Matchers::Record

  let(:book) { create(:book) }

  before do
    get :show, id: book.id
  end

  it "responds with the correct book" do
    expect(response).to have_record(book)
  end
end
```


`Note: Works for responses where data is an array or an object`


#### Checking the `included` resources

```ruby
expect(response).to include_record(record)
```

```ruby
RSpec.describe BooksController do
  include Jsonapi::Matchers::Record

  let(:author) { create(:author) }
  let!(:book1) { create(:book, author: author) }
  let!(:book2) { create(:book, author: author) }

  before do
    get :index
  end

  it "includes the author" do
    expect(response).to include_record(author)
  end

  it "has the correct books" do
    expect(response).to have_record(book1)
    expect(response).to have_record(book2)
  end
end
```


#### Checking attributes values

```ruby
expect(response).to have_id('id')
```

```ruby
expect(response).to have_type('object_type')
```

```ruby
expect(response).to have_attribute('attribute_name')
```

```ruby
expect(response).to have_attribute('attribute_name').with_value('attribute_value')
```

```ruby
RSpec.describe BooksController do
  include Jsonapi::Matchers::Attributes

  let(:author) { create(:author) }
  let(:book) { create(:book, author: author, name: 'Moby Dick') }

  before do
    get :show, id: book.id
  end

  it "has the correct book" do
    expect(response).to have_id(book.id)
  end

  it "has the correct type" do
    expect(response).to have_type('books')
  end

  it "includes the name attribute" do
    expect(response).to have_attribute('name')
  end

  it "includes the correct attribute value" do
    expect(response).to have_attribute('name').with_value('Moby Dick')
  end
end
```


#### Supports ActionDispatch::TestResponse, ActionController::TestResponse, and Hash

```
expect(response).to have_id(book.id)
```

OR

```
expect(JSON.parse(response.body)).to have_id(book.id)
```
