class Game < ApplicationRecord
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player", optional: true #Default es required, y yo no voy a poder asignar un player2 hasta que el player2 no se una al game
    
    #Constante
    WINS = [
                [0, 1, 2],
                [3, 4, 5],
                [6, 7, 8],
                [0, 3, 6],
                [1, 4, 7],
                [2, 5, 8],
                [0, 4, 8],
                [2, 4, 6],
            ];

    #Metodo de instancia para verificar si hay un ganador
    def winner_game
        winner_result=self.result.split(",") #Paso el resultado desde string a array
        

        Game::WINS.each do |combination| #En cada vuelta, combination toma el valor de una fila distinta de la constante WINS
            a = combination[0]
            b = combination[1]
            c = combination[2]

           if (winner_result[a]=="O" && winner_result[a] === winner_result[b] && winner_result[a] === winner_result[c])
               self.winner=self.player1_id
           end

           if (winner_result[a]=="X" && winner_result[a] === winner_result[b] && winner_result[a] === winner_result[c])
               self.winner=self.player2_id
           end
        end#Termina codigo que averigua si hay un ganador
    end

end

