# README

# Player

| Descripciòn                            | Metodo | Ruta                   | Controller#Action | params_query     | ResponsePositiva    | ResponseNegativa                       |
| -------------------------------------- | ------ | ---------------------- | ----------------- | ---------------- | ------------------- | -------------------------------------- |
| Muestra todo los jugadores registrados | GET    | /players(.:format)     | players#index     | Ninguno          | {players: @players} | En el front no se mostra ni un jugador |
| Crea un nuevo jugador                  | POST   | /players(.:format)     | players#create    | nombre, password | {player: @player}   | {message: @game.errors.details}        |
| Muestra un solo jugador                | GET    | /players/:id(.:format) | players#show      | nombre           | {player: @player}   | { message: "No esta #{params[:id]}"}   |

# Game

| Descripciòn                                                           | Metodo | Ruta                            | Controller#Action    | params_query        | ResponsePositiva | ResponseNegativa                     |
| --------------------------------------------------------------------- | ------ | ------------------------------- | -------------------- | ------------------- | ---------------- | ------------------------------------ |
| Muestra todo los games                                                | GET    | /games(.:format)                | games#index          | Ninguno             | {games: @games}  | En el front no se mostra ni un game  |
| Recupera un game                                                      | GET    | /games/:id(.:format)            | games#show           | id                  | {game: @game}    | { message: "No esta #{params[:id]}"} |
| Crea un nuevo game                                                    | POST   | /games(.:format)                | games#create         | plaer1_id, gameName | {game: @game}    | {message: @game.errors.details}      |
| Muestra todos los games en espera de un segundo jugador para empiezar | GET    | /games/indexOpenGames(.:format) | games#indexOpenGames | Ninguno             | {games: @games}  | No se muestra ni un games            |
