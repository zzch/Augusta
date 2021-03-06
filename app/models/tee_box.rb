# -*- encoding : utf-8 -*-
class TeeBox < ActiveRecord::Base
  as_enum :color, [:red, :white, :blue, :black, :gold], prefix: true, map: :string
  belongs_to :hole
  default_scope { order(:distance_from_hole) }
  validates :distance_from_hole, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999 }

  class << self
    [:red, :white, :blue, :black, :gold].each do |color|
      define_method(color) do
        send("color_#{color}s").first
      end
    end
  end
end
