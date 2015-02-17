# Kleisli::Validation

A Validation monad built on top of the nice [Kleisli](https://github.com/txus/kleisli)
gem.

Validation is like an Either, but it allows you to accumulate Failures of the
same Semigroup using the applicative functor's apply operator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kleisli-validation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kleisli-validation

## Usage

Usage is practically identical to the [Either](https://github.com/txus/kleisli#either)
Monad provided by kleisli, substituting Success for Right (and .success for .right)
as well as Failure for Left (and .failure for .left).

The main difference is in the handling of errors when using the applicative
functor's apply, as seen here.

```ruby
require "kleisli"

add = -> x, y { x + y }
Success(add) * Success(10) * Success(2)
# => Success(12)
Success(add) * Failure("error") * Success(2)
# => Failure("error")

# new case supported by Validation
add3 = -> x, y, z { x + y + z }
Success(add) * Failure(["error"]) * Failure(["another error"])
# => Failure(["error", "another error"])
```


###Semigroups

The values inside your Failures must all belong to the same Semigroup in
order to accumulate errors using the apply operator.

A Semigroup is any class that implements the sappend method as follows:

```haskell
sappend :: a -> a -> a
```

This gem provides a Semigroup monkeypatch for Array and Hash, see
semigroup\_instances.rb for examples and implementation.

Using Failure values with no sappend implementation or Failure values of
differing types in one application will yield an ArgumentError.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kleisli-validation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
