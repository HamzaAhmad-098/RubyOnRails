class AddAnswerImageToEvaluations < ActiveRecord::Migration[8.0]
  def change
    add_column :evaluations, :answer_image, :string
  end
end
