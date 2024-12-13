unit Player;

interface

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}

uses Raylib, Game, Animations;

type

  TPlayer = class(TObject)

  private

    sprite_size : TVector2;
    velocity: TVector2;
    animations : TAnimations;

  public
    pos: TVector2;
    sprite: TTexture2D;
    constructor Create(Game: TGame; pos: TVector2);
    procedure Update();
    procedure Render(Game: TGame);

  end;

 PPlayer = ^TPlayer;

implementation

{ TPlayer }

constructor TPlayer.Create(Game: TGame; pos: TVector2);
begin

  self.pos := pos;
  self.sprite := game.textures['player_idle'];

  self.sprite_size := TVector2.Create(16,16);

  self.animations := TAnimations.Create(Game);
  self.animations.LoadAnimation('idle', 2, 0.2, true, self.sprite);


end;

procedure TPlayer.Render(Game: TGame);
begin

  self.animations.PlayAnimation('idle', self.pos, self.sprite_size);

  if boolean(game.debug_mode) then
  DrawRectangle(round(self.pos.X) - 8, round(self.pos.Y) - 8, sprite.Width div 2, sprite.Height, TColor.Create(0,255,0,100));


end;

procedure TPlayer.Update;
begin

  velocity.X := 0;
  velocity.Y := 0;

  if IsKeyDown(KEY_D) then
  begin
    velocity.X := 1.5
  end;

  if IsKeyDown(KEY_A) then
  begin
    velocity.X := -1.5
  end;

  if IsKeyDown(KEY_W) then
  begin
    velocity.Y := -1.5
  end;

  if IsKeyDown(KEY_S) then
  begin
    velocity.Y := 1.5
  end;

  pos.X := pos.X + int(velocity.X);
  pos.Y := pos.Y + int(velocity.Y);


  end;

end.
