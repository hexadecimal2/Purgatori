unit Gun;

interface

uses
  raylib,
  raymath,
  Math,
  Game,
  Player;

type
  gun_direction = (left, right);

  TGun = class(TObject)

  public

    pos: TVector2;

    constructor Create(Game: TGame; Player: TPlayer; offset : integer);
    procedure Render(Game : TGame);
    procedure Update(Player : TPlayer; cam : TCamera2D);

  private

    sound : TSound;
    rotation : single;
    direction : gun_direction;
    sprite: TTexture2D;
    source : TRectangle;
    offset : integer;

  end;



implementation

{ TGun }

constructor TGun.Create(Game: TGame; Player: TPlayer; offset : integer);
begin

  Self.pos := Player.pos;
  Self.pos.X := Self.pos.X + offset;
  Self.sprite := game.textures['gun'];
  Self.offset := offset;

  direction := right;

  source := TRectangle.Create(0,0,16,16);


end;

procedure TGun.Render(Game: TGame);
begin

 DrawTexturePro(self.sprite,
 source,
 TRectangle.Create(self.pos.X, self.pos.Y , 16,16),
 TVector2.Create(8,8),
 self.rotation,
 WHITE);

 //DrawLineEX(TVector2.Create(self.pos.X, self.pos.Y), TVector2.Create(GetMouseX / 2, GetMouseY / 2), 2,  BLACK);

 DrawText(TextFormat('gun rotation : %f', self.rotation), 10, 60, 10, BLACK);

 end;

procedure TGun.Update(Player: TPlayer; cam : TCamera2D);
var
mousechangex, mousechangey : single;
begin

  mousechangex := GetMouseX / 2 - self.pos.X - cam.Offset.X;
  mousechangey := GetMouseY / 2 - self.pos.Y - cam.Offset.Y;

  self.rotation := (180 / System.Pi) * ArcTan2(mousechangey, mousechangex);


  if GetMouseX / 2 - cam.Offset.X < self.pos.X - source.Width then
  begin
   direction := left;
  end
  else if GetMouseX / 2 - cam.Offset.X > self.pos.X + source.Width then
  begin
    direction := right;
  end;

  if IsKeyDown(KEY_W) then
  begin
    self.pos.Y := Player.pos.Y;
  end;

  if IsKeyDown(KEY_S) then
  begin
    self.pos.Y := Player.pos.Y;
  end;

  case direction of
    left:
    begin
    self.pos.X := Player.pos.X - offset - 1;
    source.Height := -16;
    end;

    right:
    begin
    self.pos.X := Player.pos.X + offset ;
    source.Height := 16;
    end;
  end;


end;

end.
