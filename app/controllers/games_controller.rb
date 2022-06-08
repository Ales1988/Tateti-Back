class GamesController < ApplicationController
    
    #callback
    before_action :set_game, only:[ :show]

    #actions
    def index
        @games = Game.all
        render status: 200, json: {games: @games}
    end

    def show
        render status: 200, json: {game: @game}
    end

    #player1_id: @player1_id, gameName: @gameName
    def create
        @game = Game.new() 
        @player=Player.find_by(id: params[:player1_id])
        @game.player1 = @player
        @game.gameName = params[:gameName]
        
        game_save
    end

    #action para mostrarme todos los games donde player2 es nil...asi en el front el segundo jugador puede elegir un game que està esperando un jugador para empiezar
    def indexOpenGames
        @games = Game.where(player2_id: [nil, ""])
        render status: 200, json: {games: @games}
    end

    #action para asignar el segundo jugador a un game
    def update
        @game=Game.find_by(id: params[:gameId])
        @game.player2_id = params[:player2_id]
        game_save
    end
    
    #Cada vez que en el front se marca una celda, guardo la modificaciòn. Tambien incremento de 1 el turno
    def saveResult
        @game=Game.find_by(id: params[:gameId])
        return if @game.winner!=0 #No me deja jugar si ya hay un ganador

        @game.result=params[:result]
        @game.turn=@game.turn+1 #Incremento el turno en 1, porque marcar una celda representa un turno

        resultado=@game.result.split(",") #Paso el resultado desde string a array

        #Empieza el codigo que averigua si alguien ganò. Tengo que correrlo cada vez que un jugador marca una celda
        #Un metodo check_win seria un metodo de instancia, entonces habria que ponerlo en el model y acà simplemente @game.check_win
        combinacionesGanadoras = [
                [0, 1, 2],
                [3, 4, 5],
                [6, 7, 8],
                [0, 3, 6],
                [1, 4, 7],
                [2, 5, 8],
                [0, 4, 8],
                [2, 4, 6],
            ];

            for i in 0..7 do
                a = combinacionesGanadoras[i][0]
                b = combinacionesGanadoras[i][1]
                c = combinacionesGanadoras[i][2]

               if (resultado[a]=="O" && resultado[a] === resultado[b] && resultado[a] === resultado[c])
                   @game.winner=@game.player1_id
               end

               if (resultado[a]=="X" && resultado[a] === resultado[b] && resultado[a] === resultado[c])
                   @game.winner=@game.player2_id
               end
            end#Termina codigo que averigua si hay un ganador

        game_save
    end
   
 
    def game_save
        if @game.save 
            
            render status: 200, json: {game: @game}
        else
            render status: 400, json: {message: @game.errors.details}
        end
    end

    def set_game
        @game=Game.find_by(id: params[:id]) 
        return if @game.present? 

        render status: 404, json: { message: "No esta #{params[:id]}"}
		false 
    end

end
