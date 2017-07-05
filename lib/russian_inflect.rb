# frozen_string_literal: true

require 'yaml'
require 'unicode_utils'
require 'russian_inflect/cases'
require 'russian_inflect/detector'
require 'russian_inflect/inflector'
require 'russian_inflect/rules'
require 'russian_inflect/version'

module RussianInflect
  def self.detect_case_group(word)
    Detector.new(word).case_group
  end

  def self.detect_type(word)
    Detector.new(word).word_type
  end

  def self.inflect(text, gcase, force_downcase: false)
    Inflector.new(text).to_case(gcase, force_downcase: force_downcase)
  end

  def self.new(source, options = nil)
    Inflector.new(source, options)
  end
end
