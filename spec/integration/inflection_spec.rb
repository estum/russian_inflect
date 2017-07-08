# frozen_string_literal: true

require 'spec_helper'

describe 'Word' do
  it_inflects %w(Комментарий Комментария Комментарию Комментарий Комментарием Комментарии)
  it_inflects %w(Апрель Апреля Апрелю Апрель Апрелем Апреле)
  it_inflects %w(Декабрь Декабря Декабрю Декабрь Декабрем Декабре)
  it_inflects %w(Пароль Пароля Паролю Пароль Паролем Пароле)
end

describe 'Words' do
  it_inflects ['Большой куш', 'Большого куша', 'Большому кушу',
               'Большой куш', 'Большим кушем', 'Большом куше']
  it_inflects ['Красное вино', 'Красного вина', 'Красному вину',
               'Красное вино', 'Красным вином', 'Красном вине']
  it_inflects ['Накладка моторного отсека', 'Накладки моторного отсека',
               'Накладке моторного отсека', 'Накладку моторного отсека',
               'Накладкой моторного отсека', 'Накладке моторного отсека']
  it_inflects ['Решетка радиатора', 'Решетки радиатора', 'Решетке радиатора',
               'Решетку радиатора', 'Решеткой радиатора', 'Решетке радиатора']
  it_inflects ['Синее море', 'Синего моря', 'Синему морю',
               'Синее море', 'Синим морем', 'Синем море']
  it_inflects ['Хорошая погода', 'Хорошей погоды', 'Хорошей погоде',
               'Хорошую погоду', 'Хорошей погодой', 'Хорошей погоде']
end

describe 'Regions' do
  it_inflects %w(Алексеевское Алексеевского Алексеевскому Алексеевское Алексеевским Алексеевском)
  it_inflects %w(Галицино Галицино Галицино Галицино Галицино Галицино)
  it_inflects %w(Севастополь Севастополя Севастополю Севастополь Севастополем Севастополе)
  it_inflects %w(Ярославль Ярославля Ярославлю Ярославль Ярославлем Ярославле)
end