class RemoveOldstyleFromBeers < ActiveRecord::Migration
  def change
    remove_column :beers, :oldstyle, :string
  end
end
