class CreateDiscourseSites < ActiveRecord::Migration
  def change
    create_table :discourse_sites do |t|
      t.string :display_name
      t.string :slug
      t.text :meta
      t.string :base_url
      t.string :description
      t.string :logo_url
    end
  end
end
