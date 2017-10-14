class CreateRollbarItems < ActiveRecord::Migration[5.1]
  def change
    create_table :rollbar_items do |t|
      
      t.timestamps
    end
  end
end
