# encoding: UTF-8
# frozen_string_literal: true

require 'spec_helper'
require 'shared_examples/inflection'

RSpec.describe 'General' do
  describe 'word' do
    include_examples 'inflection', %w(Комментарий Комментария Комментарию
                                      Комментарий Комментарием Комментарии)

    include_examples 'inflection', %w(Апрель Апреля Апрелю
                                      Апрель Апрелем Апреле)

    include_examples 'inflection', %w(Декабрь Декабря Декабрю
                                      Декабрь Декабрем Декабре)

    include_examples 'inflection', %w(Пароль Пароля Паролю
                                      Пароль Паролем Пароле)
  end

  describe 'words' do
    include_examples 'inflection', ['Хорошая погода', 'Хорошей погоды',
                                    'Хорошей погоде', 'Хорошую погоду',
                                    'Хорошей погодой', 'Хорошей погоде']

    include_examples 'inflection', ['Большой куш', 'Большого куша',
                                    'Большому кушу', 'Большой куш',
                                    'Большим кушем', 'Большом куше']

    include_examples 'inflection', ['Синее море', 'Синего моря',
                                    'Синему морю', 'Синее море',
                                    'Синим морем', 'Синем море']

    include_examples 'inflection', ['Красное вино', 'Красного вина',
                                    'Красному вину', 'Красное вино',
                                    'Красным вином', 'Красном вине']

    include_examples 'inflection', ['Накладка моторного отсека', 'Накладки моторного отсека',
                                    'Накладке моторного отсека', 'Накладку моторного отсека',
                                    'Накладкой моторного отсека', 'Накладке моторного отсека']

    include_examples 'inflection', ['Решетка радиатора', 'Решетки радиатора',
                                    'Решетке радиатора', 'Решетку радиатора',
                                    'Решеткой радиатора', 'Решетке радиатора']
  end
end
