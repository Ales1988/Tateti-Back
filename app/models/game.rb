class Game < ApplicationRecord
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player", optional: true #Default es required, y yo no voy a poder asignar un player2 hasta que el player2 no se una al game
end

