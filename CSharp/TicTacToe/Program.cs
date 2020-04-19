using System;
using System.ComponentModel;
//using Fucntion = Func;

#nullable disable

class Program
{
    static TicTacToe ticTacToe;
    static void Main(string[] args)
    {
        Console.WriteLine("Main start");
        //for (var i = 0; i < 5; i++)
        //{
        //    Console.WriteLine("Hello, World");
        //}

        ticTacToe = new TicTacToe(
            SelectSymbolPlayer1,
            GetPlayerInput,
            InvalidMove,
            PlayerWins,
            NobodyWins,
            RefreshBoard
            );
        //ticTacToe.SelectSymbolPlayer1 = SelectSymbolPlayer1;
        //ticTacToe.InvalidMove = InvalidMove;

        ticTacToe.Play();

        Console.WriteLine("Main end");
    }

    //private static Coordinate PlayerAction(Player arg)
    //{
    //    throw new NotImplementedException();
    //}

    private static void RefreshBoard(Board Board)
    {
        //throw new NotImplementedException();
        //Console.WriteLine("-----------");
        for (var x = 0; x < 3; x++)
        {
            //Console.Write("|");
            for (var y = 0; y < 3; y++)
            {
                var value = Board.board[x, y].Value;
                string character = " ";
                character = value is Unassigned ? " " : character;
                character = value.Equals(Symbol.Circle) ? "O" : character;
                character = value.Equals(Symbol.Cross) ? "X" : character;

                //Console.Write($"{character}|");
                Console.Write($"[{character}]");
            }
            //Console.Write("|");
            Console.WriteLine();
        }
        //Console.WriteLine("-----------");
    }

    private static void PlayerWins(Player player)
    {
        //throw new NotImplementedException();
        Console.WriteLine($"Player {player.Symbol} Wins");

    }

    private static void NobodyWins()
    {
        //throw new NotImplementedException();
        Console.WriteLine("Nobody Wins");
    }

    static Symbol SelectSymbolPlayer1()
    {
        Console.WriteLine("Please select symbol for player 1 ( Cross or Circle )" );
        var input = Console.ReadLine();
        var symbol  = (Symbol)Enum.Parse(typeof(Symbol), input); 

        return symbol;
    }

    static void InvalidMove()
    {
        Console.WriteLine("This move is invalid");
        GetPlayerInput(ticTacToe.CurrentPlayer);
    }
    static Coordinate GetPlayerInput(Player player)
    {
        Console.WriteLine("Please select where to put chip" + player.Symbol.ToString());
        Console.WriteLine("Please select your x position ");
        var x = Convert.ToInt32(Console.ReadLine()); 
        Console.WriteLine("Please select your y position ");
        var y = Convert.ToInt32(Console.ReadLine());

        return new Coordinate(x, y);
    }
}



class TicTacToe
{
    public Board Board { get; set; } = new Board();
    public Player player1 { get; set; } = new Player();
    public Player player2 { get; set; } = new Player();

    public Player CurrentPlayer { get; set; } = new Player();
    public Player NextPlayer { get; set; } = new Player();
    public Symbol Symbol { get; set; } = Symbol.Cross;


    public Func<Symbol> SelectSymbolPlayer1 { get; set; } = () => Symbol.Cross;
    public Func<Player, Coordinate> GetPlayerInput { get; set; } = (player) => new Coordinate();
    //public Func<Player,Coordinate> PlayAction { get; set; } = (player) => new Coordinate();

    public Action InvalidMove { get; set; } = () => { };
    public Action<Player> PlayerWins { get; set; } = (player) => { };
    public Action NobodyWins { get; set; } = () => { };
    public Action<Board> RefreshBoard { get; set; } = (board) => { };

    public TicTacToe(Func<Symbol> SelectSymbolPlayer1, Func<Player, Coordinate> GetPlayerInput, Action InvalidMove, Action<Player> PlayerWins, Action NobodyWins, Action<Board> RefreshBoard
        //, Func<Player,Coordinate> PlayAction
        )
    {
        this.SelectSymbolPlayer1 = SelectSymbolPlayer1;
        this.GetPlayerInput = GetPlayerInput;
        this.InvalidMove = InvalidMove;
        this.PlayerWins = PlayerWins;
        this.NobodyWins = NobodyWins;
        this.RefreshBoard = RefreshBoard;
    }

    public void Play()
    {
        Symbol = SelectSymbolPlayer1();

        player1.Symbol = Symbol;
        player2.Symbol = Symbol == Symbol.Circle ? Symbol.Cross : Symbol.Circle;

        player1.PlayAction = () => this.GetPlayerInput(player1);
        player2.PlayAction = () => this.GetPlayerInput(player2);

        NextPlayer = player1;

        Board.InvalidMove = this.InvalidMove;
        Board.RefreshBoard = this.RefreshBoard;
        while (!gameOver())
        {
            nextPlayerPlay();
        }
    }
    //public async void PlayAsync()
    //{
    //    Symbol = await SelectSymbolPlayer1Async();

    //    player1.Symbol = Symbol;
    //    player2.Symbol = Symbol == Symbol.Circle ? Symbol.Cross : Symbol.Circle;

    //    Board.InvalidMove = this.InvalidMove;
    //    while (! await gameOverAsync())
    //    {
    //        await nextPlayerPlayAsync();
    //    }
    //}

    public void nextPlayerPlay()
    {
        this.NextPlayer.Play(Board);
        PrepareNextPlayer();
    }
    public void PrepareNextPlayer()
    {
        if (this.NextPlayer == player1)
        {
            this.CurrentPlayer = player1;
            this.NextPlayer = player2;
        }
        else
        {
            this.CurrentPlayer = player2;
            this.NextPlayer = player1;
        }
    }

    private bool gameOver()
    {
        

        var somebodyWins =
            someBodyWinsHorizontal()
            ||
            someBodyWinsVertical()
            ||
            someBodyWinsDiagonal();
        var isBoardFull = IsBoardFull(Board);

        var gameOver = somebodyWins || isBoardFull;

        return gameOver;

    }


    bool someBodyWinsHorizontal()
    {
        //PlayerWins(Player);

        //NobodyWins(Player);

        //iterate for x
        for (int i = 0; i < 3; i++)
        {
            if ( Board.board[i, 0].Value is Unassigned )
                continue;
            if ( Board.board[i, 1].Value is Unassigned )
                continue;
            if ( Board.board[i, 2].Value is Unassigned )
                continue;

            if ( Board.board[i,0].Value == Board.board[i, 1].Value && Board.board[i, 1].Value == Board.board[i, 2].Value)
            {
                return true;
            }
        }

        return false;
    }
    bool someBodyWinsVertical()
    {
        //PlayerWins(Player);

        //NobodyWins(Player);

        //iterate for x
        for (int i = 0; i < 3; i++)
        {
            if ( Board.board[0, i].Value is Unassigned )
                continue;
            if ( Board.board[1, i].Value is Unassigned )
                continue;
            if ( Board.board[2, i].Value is Unassigned)
                continue;

            if (Board.board[0, i].Value == Board.board[1, i].Value && Board.board[1, i].Value == Board.board[2, i].Value)
            {
                PlayerWins(CurrentPlayer);
                return true;
            }
        }

        return false;
    }
    bool someBodyWinsDiagonal()
    {

        var someBodyWinsDiagonal = someBodyWinsDiagonalNormal() || someBodyWinsDiagonalInverted();

        return someBodyWinsDiagonal;
    }
    bool someBodyWinsDiagonalNormal()
    {
        //Diagonal 1
        if ( Board.board[0, 2].Value is Unassigned )
            return false;
        if ( Board.board[1, 1].Value is Unassigned )
            return false;
        if ( Board.board[2, 0].Value is Unassigned )
            return false;

        if (Board.board[0, 2].Value.Equals(Board.board[1, 1].Value) && Board.board[1, 1].Value.Equals(Board.board[2, 0].Value) )
        {
            PlayerWins(CurrentPlayer);
            return true;
        }

        return false;
    }

    bool someBodyWinsDiagonalInverted()
    {
        //Diagonal 2

        if ( Board.board[0, 0].Value is Unassigned )
            return false;
        if ( Board.board[1, 1].Value is Unassigned )
            return false;
        if ( Board.board[2, 2].Value is Unassigned )
            return false;

        if ( Board.board[0, 0].Value.Equals(Board.board[1, 1].Value) && Board.board[1, 1].Value.Equals(Board.board[2, 2].Value) )
        {
            PlayerWins(CurrentPlayer);
            return true;
        }

        return false;
    }


    bool IsBoardFull( Board Board)
    {

        //iterate for x
        for (int i = 0; i < 3; i++)
        {
            //iterate for x
            for (int j = 0; j < 3; j++)
            {
                if (  Board.board[i, j].Value is Unassigned  )
                {
                    return false;
                }
            }
        }

        NobodyWins();

        return true;
    }
}

class Board
    //: Matrix<Symbol,Symbol,Symbol>
    //: INotifyPropertyChanged
{
    public UnassignedOrSymbol[,] board { get; set; } = new UnassignedOrSymbol[3, 3]
        {
            { new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default)  },
            { new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default)  },
            { new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default),new UnassignedOrSymbol(Unassigned.@default)  },
        };
    public Action<Board> RefreshBoard { get; set; } = (board) => { };
    public Action InvalidMove { get; set; } = () => { };
    public bool ThrowException { get; set; } = false;

    public Board()
    {

    }

    public void UseChip(int x, int y, Symbol chip)
    {
        Validate(x, y);// throws exception.

        board[x,y] = new UnassignedOrSymbol ( chip );
        RefreshBoard(this);
    }


    void Validate (int x, int y)
    {
        if ( !( 0 <= x && x <= 2 ) )
        {
            InvalidMove();
            if ( ThrowException )
                throw new ArgumentException("");
        }
        if ( !( 0 <= y && y <= 2 ) )
        {
            InvalidMove();
            if (ThrowException)
                throw new ArgumentException("");
        }

        if ( ! ( board[x, y].Value is Unassigned) )
        {
            InvalidMove();
            if (ThrowException)
                throw new ArgumentException("");
        }
    }

    

}

class UnassignedOrSymbol
{
    public object Value { get; set; } = Unassigned.@default;

    public UnassignedOrSymbol( Symbol symbol  )
    {
        Value = symbol;
    }
    public UnassignedOrSymbol(Unassigned unassigned)
    {
        Value = unassigned;
    }
}
public sealed class Unassigned
{
    public static Unassigned @default = new Unassigned();

    private Unassigned(){}
}

class Player
{
    public Func<Coordinate> PlayAction { get; set; } = () => new Coordinate();
    public Symbol Symbol { get; set; } = Symbol.Cross;
    public Board Board { get; set; } = new Board();

    public void Play(Board Board)
    {
        var Coordinate = PlayAction();
        Board.UseChip(Coordinate.X, Coordinate.Y, this.Symbol);
    }

}

class Coordinate //: Tuple<int, int>
{
    public int X { get; set; }
    public int Y { get; set; }

    public Coordinate() : this(0,0)
    {

    }
    public Coordinate( int X, int Y)
    {
        this.X = X;
        this.Y = Y;
    }
}

enum Symbol
{
    [Description("O")]
    Circle = 0,

    [Description("X")]
    Cross = 1
}

