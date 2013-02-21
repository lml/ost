class CreateMailHooks < ActiveRecord::Migration
  def change
    create_table :mail_hooks do |t|
      t.string :mail_hookable_type
      t.integer :mail_hookable_id
      t.integer :max_num_uses
      t.integer :current_num_uses
      t.string :subject
      t.string :to_email
      t.datetime :expires_at

      t.timestamps
    end

    add_index :mail_hooks, [:mail_hookable_id, :mail_hookable_type], :name => 'mail_hookable_index'
    add_index :mail_hooks, [:subject, :to_email], :uniqueness => true, :name => 'index_mail_hooks_on_subject_scoped'
  end
end
