class CreateSsrFreelanceSettings < ActiveRecord::Migration
  def change
    create_table :ssr_freelance_settings do |t|
      t.references :role, foreign_key: true
      t.boolean :freelance_role
    end
  end
end
