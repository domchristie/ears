class AddSourceableToFollowings < ActiveRecord::Migration[7.0]
  def change
    add_reference :followings, :sourceable, polymorphic: true
  end
end
