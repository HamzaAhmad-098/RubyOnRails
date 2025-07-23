class CreateEvaluations < ActiveRecord::Migration[8.0]
  def change
    create_table :evaluations do |t|
      t.text :question_text
      t.text :student_answer
      t.integer :marks
      t.integer :ai_score
      t.text :ai_feedback
      t.text :instructions

      t.timestamps
    end
  end
end
