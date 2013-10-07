# RussianInflect

Склонение по падежам заголовков на русском языке.  

Многое подсмотрено в геме [petrovich](https://github.com/rocsci/petrovich). Различие в том, что RussianInflect склоняет не имена и фамилии, а словосочетания, например, названия товаров. 

## Installation

Add this line to your application's Gemfile:

    gem 'russian_inflect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install russian_inflect

## Usage

```ruby
RussianInflect.inflect("Хорошая погода", :nominative)     # => Хорошая погода
RussianInflect.inflect("Хорошая погода", :genitive)       # => Хорошей погоды
RussianInflect.inflect("Хорошая погода", :dative)         # => Хорошей погоде
RussianInflect.inflect("Хорошая погода", :accusative)     # => Хорошую погоду
RussianInflect.inflect("Хорошая погода", :instrumental)   # => Хорошей погодой
RussianInflect.inflect("Хорошая погода", :prepositional)  # => Хорошей погоде
```

или

```ruby
words = RussianInflect.new("Хорошая погода")
words.to_case :genitive     # => Хорошей погоды
words.to_case :dative       # => Хорошей погоде
# etc...
```

## Помощь гему
* Нужны тесты для всяких окончаний, исключений и т.п.   
  Дополнять их просто: в [spec/lib/russian_inflect_spec.rb](/estum/russian_inflect/blob/master/spec/lib/russian_inflect_spec.rb) нужно добавить пример словосочетания и правильные результаты склонения по аналогии с уже добавленными примерами.
* Правила склонения пока далеки от идеала и тоже ждут своего Розенталя. Они похожи на правила из гема [petrovich](https://github.com/rocsci/petrovich) и находятся в [lib/russian_inflect/rules.yml](/lib/russian_inflect/rules.yml).
* Как видите, ридми тоже не мешало бы переписать.
