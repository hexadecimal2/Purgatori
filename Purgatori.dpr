program Purgatori;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in 'raylib\raylib.pas',
  raymath in 'raylib\raymath.pas',
  rlgl in 'raylib\rlgl.pas',
  Game in 'Game.pas',
  Player in 'Player.pas',
  Gun in 'Gun.pas',
  Cursor in 'Cursor.pas',
  Bullet in 'Bullet.pas',
  Background in 'Background.pas',
  Bat in 'Bat.pas',
  Animations in 'Animations.pas';

begin
  try
    // set current directory to exe path
    SetCurrentDir(ExtractFilePath(ParamStr(0)));

    TGame.Create;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
