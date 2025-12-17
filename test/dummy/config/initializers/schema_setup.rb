if Rails.env.development? && !ActiveRecord::Base.connection.table_exists?(:contacts)
  ActiveRecord::Schema.define do
    create_table :contacts, force: true do |t|
      t.string :name
      t.string :email
      t.timestamps
    end

    create_table :siblings, force: true do |t|
      t.references :contact, null: false, foreign_key: true
      t.string :name
      t.string :age
      t.timestamps
    end

    create_table :phones, force: true do |t|
      t.references :sibling, null: false, foreign_key: true
      t.string :number
      t.string :phone_type
      t.timestamps
    end
  end
end
