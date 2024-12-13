unit Bullet;

interface
{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}
uses
  SysUtils,
  Raylib,
  Math,
  Game,
  Background,
  Player,
  Generics.Collections,
  Gun;

type

  TBullet = class(TObject)

  public

    pos : TVector2;
    hitbox : TRectangle;

    constructor Create(Game: TGame; Gun: TGun; cam : TCamera2D);
    procedure Update(Game: TGame; Gun: TGun; Bullets : TList<TBullet>; bg : TBackground; player : TPlayer);
    procedure Render(Game: TGame);

  private

    velocity: TVector2;
    angle: Single;
    mousedistancex, mousedistancey: Single;


  end;

implementation

{ TBullet }

constructor TBullet.Create(Game: TGame; Gun: TGun; cam : TCamera2D);
begin

  self.pos := Gun.pos;

  mousedistancex := (GetMouseX / 2) - self.pos.X - cam.Offset.X;
  mousedistancey := (GetMouseY / 2) - self.pos.Y - cam.Offset.Y;

  angle := ArcTan2(mousedistancey, mousedistancex);

  velocity.X := Cos(angle) * 5;
  velocity.Y := Sin(angle) * 5;

  hitbox := TRectangle.Create(self.pos.X, self.pos.Y, 5,5);
  
  end;

procedure TBullet.Update(Game: TGame; Gun: TGun; Bullets : TList<TBullet>; bg : TBackground; player : TPlayer);
var
bullet : TBullet;
begin

 self.pos.X := self.pos.X + self.velocity.X;
 self.pos.Y := self.pos.Y + self.velocity.Y;

 hitbox.X := self.pos.X - 2;
 hitbox.Y := self.pos.Y - 2;
 
 if (self.pos.X > bg.pos1.x + 400) or (self.pos.X < bg.pos1.X) or 
 (self.pos.Y < player.pos.Y - 300) or (self.pos.Y > player.pos.Y + 300 ) then
 begin
   self.Free;
   Bullets.Remove(self);
 end;




end;

procedure TBullet.Render(Game: TGame);
begin
  DrawCircle(trunc(self.pos.X), trunc(self.pos.Y), 2, BLACK);
  DrawCircleLines(trunc(self.pos.X), trunc(self.pos.Y), 3, WHITE);

  if Boolean(game.debug_mode) then
  DrawRectangleRec(self.hitbox, BLUE);

end;

end.
