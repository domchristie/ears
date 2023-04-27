class AddSourceToSynchronizations < ActiveRecord::Migration[7.0]
  def change
    add_column :synchronizations, :source, :string, null: false
  end
end
