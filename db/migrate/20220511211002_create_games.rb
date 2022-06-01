class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.belongs_to :player1
      t.belongs_to :player2
      t.string :gameName, unique: true
      t.string :result, default:",,,,,,,," #String que las comas dividen en 9 posiciones (cada una representa una celda del tablero), para guardar el resultado del game cada vez que un usuario seleciona una celda
      t.integer :turn, default: 0
      t.integer :winner, default: 0
      t.timestamps
    end
  end
end
