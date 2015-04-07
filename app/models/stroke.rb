class Stroke < ActiveRecord::Base
  include UUID
  belongs_to :scorecard
  as_enum :point_of_fall, [:fairway, :green, :left_rough, :right_rough, :bunker, :unplayable], prefix: true, map: :string
  as_enum :club, ['1w', '3w', '5w', '7w', '2h', '3h', '4h', '5h', '1i', '2i', '3i', '4i', '5i', '6i', '7i', '8i', '9i', 'pw', 'gw', 'sw', 'lw', 'pt'], prefix: true, map: :string
  before_create :setup_sequence
  after_save :recalculate_scorecard
  after_destroy :reorder_sequence, :recalculate_scorecard
  scope :by_scorecard, ->(scorecard_id) { where(scorecard_id: scorecard_id) }
  scope :sorted, -> { order(:sequence) }

  protected
    def setup_sequence
      self.sequence = Stroke.by_scorecard(self.scorecard).count + 1
    end

    def recalculate_scorecard
      self.scorecard.calculate!
    end

    def reorder_sequence
      Stroke.by_scorecard(self.scorecard).each_with_index.map{|stroke, i| stroke.update!(sequence: i + 1)}
    end
end