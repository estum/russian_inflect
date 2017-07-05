# encoding: UTF-8
# frozen_string_literal: true

require 'spec_helper'
require 'shared_examples/inflection'

RSpec.describe 'Region' do
  # include_examples 'inflection', %w(Алексеевское Алексеевского Алексеевскому
  #                                   Алексеевское Алексеевским Алексеевском)

  include_examples 'inflection', %w(Севастополь Севастополя Севастополю
                                    Севастополь Севастополем Севастополе)

  # include_examples 'inflection', %w(Галицино Галицино Галицино
  #                                   Галицино Галицино Галицино)

  include_examples 'inflection', %w(Ярославль Ярославля Ярославлю
                                    Ярославль Ярославлем Ярославле)
end
