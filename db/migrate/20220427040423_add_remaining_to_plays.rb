class AddRemainingToPlays < ActiveRecord::Migration[7.0]
  def change
    add_column :plays, :remaining, :float, default: 0.0
  end
end
