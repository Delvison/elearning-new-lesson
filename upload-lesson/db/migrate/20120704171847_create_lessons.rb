class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :goal
      #t.integer :course_id
	t.references :course

      t.timestamps
    end
  end
end
