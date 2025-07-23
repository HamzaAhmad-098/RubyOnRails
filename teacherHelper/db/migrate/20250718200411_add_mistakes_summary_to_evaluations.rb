class AddMistakesSummaryToEvaluations < ActiveRecord::Migration[8.0]
  def change
    add_column :evaluations, :mistakes_summary, :text
  end
end
