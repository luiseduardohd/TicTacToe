//
//  main.swift
//  TicTatToe
//
//  Created by Luis Eduardo Hdz on 18/04/20.
//  Copyright © 2020 Luis Eduardo Hdz. All rights reserved.
//

import Foundation

enum Exception:Error{
    case ArgumentException(String)
}



func RefreshBoard(Board:Board) -> Void{
    //throw NotImplementedException();
    //print("-----------");
    for  x in 0..<3 {
        //print("|");
        for y in 0..<3 {
            let value = Board.board[x][y];
            var character = " "
            character = value.isNil ? " " : character
            character = value! == Symbol.Circle ? "O" : character
            character = value! == Symbol.Cross ? "X" : character
            //print($"{character}|");
            print("[\(character)]")
        }
        //print("|");
        print();
    }
    //print("-----------");
}

func PlayerWins(player:Player) -> Void{
    //throw NotImplementedException();
    print("Player \(String(describing: player.Symbol)) Wins")
}

func NobodyWins() -> Void{
    //throw NotImplementedException();
    print("Nobody Wins");
}

func SelectSymbolPlayer1() -> Symbol{
    print("Please select symbol for player 1 ( Cross or Circle )" )
    let input = readLine()!
    let symbol  = Symbol(rawValue: input)!

    return symbol
}

func InvalidMove() -> Void{
    print("This move is invalid");
    //GetPlayerInput(player: ticTacToe.CurrentPlayer);
}
func GetPlayerInput(player:Player ) -> Coordinate{
    print("Please select where to put chip" + player.Symbol.rawValue)
    print("Please select your x position ")
    let x = Int(readLine()!)!
    print("Please select your y position ")
    let y = Int(readLine()!)!

    return Coordinate(X: x, Y: y)
}
func PlayAction(Player:Player ) -> Coordinate{
    print("Please select where to put chip" + Player.Symbol.rawValue)
    print("Please select your x position ")
    let x = Int(readLine()!)!
    print("Please select your y position ")
    let y = Int(readLine()!)!

    return Coordinate(X: x, Y: y)
}


class TicTacToe
{
    var Board_:Board
    var player1:Player
    var player2:Player

    var CurrentPlayer:Player
    var NextPlayer:Player
    var Symbol:Symbol   = .Cross

    
    var SelectSymbolPlayer1: ()->Symbol
    var GetPlayerInput: (Player)->Coordinate
    var InvalidMove: () -> Void
    var PlayerWins: (Player) -> Void
    var NobodyWins: () -> Void
    var RefreshBoard: (Board) -> Void
    
    var PlayAction: (Player) ->Coordinate
    

    init(
        SelectSymbolPlayer1: @escaping ()->Symbol ,
        GetPlayerInput: @escaping (Player)->Coordinate ,
        InvalidMove: @escaping ()  -> Void,
        PlayerWins: @escaping (Player) -> Void ,
        NobodyWins: @escaping ()  -> Void,
        RefreshBoard: @escaping (Board) -> Void,
        PlayAction: @escaping (Player) ->Coordinate
        )
    {
        func SelectSymbolPlayer1Default() -> Symbol{
            return .Cross;
        }
        func GetPlayerInputDefault(player:Player) -> Coordinate{
            return Coordinate(X: 0,Y: 0);
        }
        func InvalidMoveDefault(){
        }
        func PlayerWinsDefault(player:Player){
        }
        func NobodyWinsDefault(){
        }
        func NobodyWinsDefault(Board:Board){
        }
        self.SelectSymbolPlayer1=SelectSymbolPlayer1Default
        self.GetPlayerInput = GetPlayerInputDefault
        //self.InvalidMove = {}()
        //self.PlayerWins =
        //self.NobodyWins = {}()
        //self.RefreshBoard = (Board_){}

        self.SelectSymbolPlayer1 = SelectSymbolPlayer1;
        self.GetPlayerInput = GetPlayerInput;
        self.InvalidMove = InvalidMove;
        self.PlayerWins = PlayerWins;
        self.NobodyWins = NobodyWins;
        self.RefreshBoard = RefreshBoard;
        
        
        self.PlayAction = PlayAction;
        
        self.Board_ = Board(RefreshBoard: self.RefreshBoard, InvalidMove: self.InvalidMove)

        self.player1 = Player(board: self.Board_,PlayAction: self.PlayAction)
        self.player2 = Player(board: self.Board_,PlayAction: self.PlayAction)

        self.CurrentPlayer = player2
        self.NextPlayer = player1
    }

    func Play(){
        Symbol = SelectSymbolPlayer1();

        player1.Symbol = Symbol;
        player2.Symbol = Symbol == .Circle ? .Cross : .Circle;

//        player1.PlayAction =  ()-> Coordinate in { return self.GetPlayerInput(self.player1); }
//        player2.PlayAction =  ()-> Coordinate in {return self.GetPlayerInput(self.player2);}

        NextPlayer = player1;

        Board_.InvalidMove = self.InvalidMove;
        Board_.RefreshBoard = self.RefreshBoard;
        while (!gameOver()){
            nextPlayerPlay();
        }
    }
    //async func PlayAsync()
    //{
    //    Symbol = await SelectSymbolPlayer1Async();

    //    player1.Symbol = Symbol;
    //    player2.Symbol = Symbol == Symbol.Circle ? Symbol.Cross : Symbol.Circle;

    //    Board.InvalidMove = self.InvalidMove;
    //    while (! await gameOverAsync())
    //    {
    //        await nextPlayerPlayAsync();
    //    }
    //}

    func nextPlayerPlay(){
        self.NextPlayer.Play(Board: Board_);
        PrepareNextPlayer();
    }
    func PrepareNextPlayer(){
        if  self.NextPlayer === player1 {
            self.CurrentPlayer = player1;
            self.NextPlayer = player2;
        }
        else{
            self.CurrentPlayer = player2;
            self.NextPlayer = player1;
        }
    }

    func gameOver() -> Bool
    {
        

        let somebodyWins =
            someBodyWinsHorizontal()
            ||
            someBodyWinsVertical()
            ||
            someBodyWinsDiagonal();
        let isBoardFull = IsBoardFull(Board:Board_);

        let gameOver = somebodyWins || isBoardFull;

        return gameOver;

    }


    func someBodyWinsHorizontal() -> Bool {
        
        //iterate for x
        for i in 0..<3 {
            if ( Board_.board[i][0].isNil ){
                continue;
            }
            if ( Board_.board[i][1].isNil ){
                continue;
            }
            if ( Board_.board[i][2].isNil ){
                continue;
            }
            

            if
                Board_.board[i][0]! == Board_.board[i][1]!
                &&
                Board_.board[i][1]! == Board_.board[i][2]! {
                return true;
            }
        }

        return false;
    }
    func someBodyWinsVertical() -> Bool {
        //iterate for x
        for i in 0..<3 {
            if ( Board_.board[0][i].isNil ){
                continue;
            }
            if ( Board_.board[1][i].isNil ){
                continue;
            }
            if ( Board_.board[2][i].isNil ){
                continue;
            }

            if
                Board_.board[0][i]! == Board_.board[1][i]!
                &&
                Board_.board[1][i]! == Board_.board[2][i]! {
                self.PlayerWins(CurrentPlayer)
                return true;
            }
        }

        return false;
    }
    func someBodyWinsDiagonal() -> Bool {

        let someBodyWinsDiagonal = someBodyWinsDiagonalNormal() || someBodyWinsDiagonalInverted();

        return someBodyWinsDiagonal;
    }
    func someBodyWinsDiagonalNormal() -> Bool {
        
        //Diagonal 1
        if ( Board_.board[0][2].isNil ){
            return false;
        }
        if ( Board_.board[1][1].isNil ){
            return false;
        }
        if ( Board_.board[2][0].isNil ){
            return false;
        }

        if
            Board_.board[0][2]! == Board_.board[1][1]!
            &&
            Board_.board[1][1]! == Board_.board[2][0]! {
            self.PlayerWins(CurrentPlayer);
            return true;
        }

        return false;
    }

    func someBodyWinsDiagonalInverted() -> Bool {
        //Diagonal 2

        if ( Board_.board[0][0].isNil ){
            return false;
        }
        if ( Board_.board[1][1].isNil ){
            return false;
        }
        if ( Board_.board[2][2].isNil ){
            return false;
        }

        if
            Board_.board[0][0] == Board_.board[1][1]!
            &&
            Board_.board[1][1]! == Board_.board[2][2]! {
            self.PlayerWins(CurrentPlayer);
            return true;
        }

        return false;
    }


    func IsBoardFull( Board:Board) -> Bool {

        //iterate for x
        for i in 0..<3 {
            //iterate for x
            for j in 0..<3 {
                if (  Board_.board[i][j].isNil  ){
                    return false;
                }
            }
        }

        //NobodyWins;

        return true;
    }
}

class Board
    //: Matrix<Symbol,Symbol,Symbol>
    //: INotifyPropertyChanged
{
    var board:[[Symbol?]]   =
        [
            [ nil,nil,nil ],
            [ nil,nil,nil ],
            [ nil,nil,nil ],
        ];
    var RefreshBoard:(Board) -> Void
    var InvalidMove:() -> Void
    var ThrowException: Bool   = false;

    init(
        RefreshBoard: @escaping (Board) -> Void,
        InvalidMove: @escaping () -> Void
    ){
        self.RefreshBoard=RefreshBoard
        self.InvalidMove=InvalidMove
    }

    func UseChip( x:Int, y:Int, chip:Symbol ){
//        try {
//            Validate( x: x, y: y);// throws exception.
//        }

        board[x][y] = chip ;
//        this.RefreshBoard(self);
    }


    func Validate ( x:Int, y:Int) throws{
        if ( !( 0 <= x && x <= 2 ) ) {
            //self.InvalidMove;
            if ( ThrowException ){
                throw Exception.ArgumentException("");
            }
        }
        if ( !( 0 <= y && y <= 2 ) ) {
            //self.InvalidMove();
            if (ThrowException){
                throw Exception.ArgumentException("");
            }
        }

        if !(board[x][y].isNil) {
            //self.InvalidMove();
            if (ThrowException){
                throw Exception.ArgumentException("");
            }
        }
    }
    
}

class Player{
    var PlayAction:(Player)->Coordinate
    var Symbol:Symbol   = .Cross;
    var Board_: Board;
    
    init(board:Board
        ,PlayAction:@escaping (Player)->Coordinate
    )
    {
        self.Board_ = board
        self.PlayAction = PlayAction
    }
    func Play(Board:Board)
    {
        let coordinate = self.PlayAction(self);
        //let coordinate = Coordinate(X: 0,Y: 0);
        Board.UseChip(x: coordinate.X, y: coordinate.Y, chip: self.Symbol);
    }
//    func ==(left: Item, right: Item) -> Bool {
//        return
//            left.item == right.item
//    }

}
//class UnassignedOrSymbol{
//    //var Value: AnyObject
//    var Value : Unassigned
//}


class Unassigned{
}

class Coordinate{ //: Tuple<int, int>{
    var X:Int
    var Y:Int

    convenience init(){
        self.init(X: 0,Y: 0)
    }
    init( X:Int, Y:Int){
        self.X = X;
        self.Y = Y;
    }
}


enum Symbol:String,Equatable{
    case Circle = "O"
    case Cross = "X"
}


func Program(){
    print("Hello, World!")

    print("Program start");

    var ticTacToe:TicTacToe
    ticTacToe = TicTacToe(
        SelectSymbolPlayer1: SelectSymbolPlayer1,
        GetPlayerInput: GetPlayerInput,
        InvalidMove: InvalidMove,
        PlayerWins: PlayerWins,
        NobodyWins: NobodyWins,
        RefreshBoard: RefreshBoard,
        PlayAction: PlayAction
        )
    //ticTacToe.SelectSymbolPlayer1 = SelectSymbolPlayer1;
    //ticTacToe.InvalidMove = InvalidMove;

    ticTacToe.Play();

    print("Program end");
}
extension Optional {

    var isNil: Bool {

        guard case Optional.none = self else {
            return false
        }

        return true

    }

    var isSome: Bool {

        return !self.isNil

    }

}

Program();

//enum TestEnum: String {
//    case name = "A Name"
//    case otherName
//    case test = "Test"
//}

//let circle: Symbol? = Symbol(rawValue: "O")
//let cross: Symbol? = Symbol(rawValue: "X")
//
//print("\(circle), \(cross)")
