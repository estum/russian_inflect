# RussianInflect

Склонение по падежам заголовков на русском языке

## Installation

Add this line to your application's Gemfile:

    gem 'russian_inflect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install russian_inflect

## Usage

    RussianInflect.inflect("Хорошая погода", :nominative)   # Хорошая погода
    RussianInflect.inflect("Хорошая погода", :genitive)   # Хорошей погоды
    RussianInflect.inflect("Хорошая погода", :dative)   # Хорошей погоде
    RussianInflect.inflect("Хорошая погода", :accusative)   # Хорошую погоду
    RussianInflect.inflect("Хорошая погода", :instrumental)   # Хорошей погодой
    RussianInflect.inflect("Хорошая погода", :prepositional)   # Хорошей погоде

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
