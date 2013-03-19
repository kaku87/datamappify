# Datamappify [![Gem Version](https://badge.fury.io/rb/datamappify.png)](http://badge.fury.io/rb/datamappify) [![Build Status](https://api.travis-ci.org/fredwu/datamappify.png)](http://travis-ci.org/fredwu/datamappify) [![Coverage Status](https://coveralls.io/repos/fredwu/datamappify/badge.png)](https://coveralls.io/r/fredwu/datamappify) [![Code Climate](https://codeclimate.com/github/fredwu/datamappify.png)](https://codeclimate.com/github/fredwu/datamappify)

Separate domain logic from data persistence, based on the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html).

__This library is current in Proof-of-Concept stage, do NOT use it for anything other than experimentation.__

## Overview

Datamappify is a thin layer on top of ActiveRecord and [Virtus](https://github.com/solnic/virtus). The design goal is to utilise ActiveRecord but separate domain logic (behaviour) and data persistence.

Datamappify consists of three components:

- __Entity__ is your model, it is responsible for mainly storing behaviour.
- __Data__ as the name suggests, holds your model data. It is an ActiveRecord object.
- __Repository__ is responsible for data retrieval and persistence, e.g. `find`, `save` and `destroy`, etc.

## Installation

Add this line to your application's Gemfile:

    gem 'datamappify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install datamappify

## Usage

### Entity

```ruby
class User
  include Datamappify::Entity

  attribute :first_name,     String
  attribute :last_name,      String
  attribute :age,            Integer
  attribute :passport,       String
  attribute :driver_license, String
  attribute :health_care,    String

  validates :first_name, :presence => true,
                         :length   => { :minimum => 2 }
  validates :passport,   :presence => true,
                         :length   => { :minimum => 8 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

### Repository

```ruby
class UserRepository
  include Datamappify::Repository

  # specify the entity class
  for_entity User

  # specify the default data provider for unmapped attributes
  default_provider :ActiveRecord

  # specify any attributes that need to be mapped
  #
  # for example:
  #   - 'gender' is mapped to the 'User' ActiveRecord class and its 'sex' attribute
  #   - 'passport' is mapped to the 'UserPassport' ActiveRecord class and its 'number' attribute
  #   - attributes not specified here are mapped automatically to 'ActiveRecord::User'
  map_attribute :last_name,      'ActiveRecord::User#surname'
  map_attribute :driver_license, 'ActiveRecord::UserDriverLicense#number'
  map_attribute :passport,       'ActiveRecord::UserPassport#number'
  map_attribute :health_care,    'ActiveRecord::UserHealthCare#number'
end
```

#### Retrieving an entity

```ruby
user = UserRepository.instance.find(1)
```

#### Saving/updating an entity

```ruby
UserRepository.instance.save(user)
```

#### Destroying an entity

Note that due to the attributes mapping, any data found in mapped ActiveRecord objects are not touched.

```ruby
UserRepository.instance.destroy(user)
```

## Changelog

Refer to [CHANGELOG](CHANGELOG.md).

## Todo

- Enforce attribute type casting.
- Hooks for persistence (`before_save` and `after_save`, etc).
- Track dirty entity attributes to avoid unnecessary DB queries.
- Support for configurable primary keys and foreign keys.
- Entity should dictate Data, so schema and migrations should be automatically generated.
- Support for multiple ORMs on attribute level.

## Similar Projects

- [Curator](https://github.com/braintree/curator)
- [Edr](https://github.com/nulogy/edr)
- [Minimapper](https://github.com/joakimk/minimapper)

## Author

[Fred Wu](http://fredwu.me/)

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
