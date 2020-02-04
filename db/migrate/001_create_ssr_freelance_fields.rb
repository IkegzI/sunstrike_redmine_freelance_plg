class CreateSsrFreelanceFields < ActiveRecord::Migration
  def change
    create_table :ssr_freelance_fields do |t|
      t.integer :field_id
    end
  end
end
