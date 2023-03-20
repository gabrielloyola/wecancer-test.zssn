class AddInfectionColumnToSurvivors < ActiveRecord::Migration[6.1]
  def change
    add_column :survivors, :infected, :boolean, default: false
  end
end
