unit Background;

interface
{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}
uses SysUtils,
Raylib,
Game,
Player,
Cursor,
Generics.Collections,
Raymath;

type

TBackground = class(TObject)

public
pos1, pos2: TVector2;

constructor Create(game : TGame; scrollspeed : integer);
procedure Update(game : TGame; player : TPlayer; var cam : TCamera2D);
procedure Render(game : TGame);


private

scrollspeed : double;
texture : TTexture2D;
posreal : TVector2;

end;


implementation

{ TBackground }

constructor TBackground.Create(game: TGame; scrollspeed : integer);
begin

self.texture := game.textures['background'];
self.scrollspeed := scrollspeed;

self.pos1 := TVector2.Create(0,0);

self.pos2 := TVector2.Create(0, 300);

self.posreal.X := pos1.X;
self.posreal.Y := pos1.Y;

end;

procedure TBackground.Render(game: TGame);
begin

DrawTexturePro(texture, TRectangle.Create(0,0,texture.Width, texture.Height / 2), TRectangle.Create(pos1.X, pos1.Y, 400,300), TVector2.Create(0,0), 0, WHITE);
DrawTexturePro(texture, TRectangle.Create(0,texture.Height / 2, texture.Width, texture.Height / 2), TRectangle.Create(pos2.X, pos2.Y, 400,300), TVector2.Create(0,0) , 0,  WHITE);

DrawText(TextFormat('posreal Y: %f ', posreal.y), 10, 120, 10, RED);

end;


procedure TBackground.Update(game: TGame; player : TPlayer; var cam : TCamera2D);
begin


pos1.Y := pos1.Y - scrollspeed * GetFrameTime;
pos2.Y := pos2.Y - scrollspeed * GetFrameTime;

if pos1.Y < posreal.Y - 300 then
begin
  pos1.Y := pos2.Y + 300;
end;

if pos2.Y < posreal.Y - 300 then
begin
  pos2.Y := pos1.Y + 300;
end;

if IsKeyDown(KEY_D) and (player.pos.X > (self.pos1.X + 340)) then
 begin
 pos1.X := pos1.X + 1;
 pos2.X := pos2.X + 1 ;
 cam.Offset.X := cam.Offset.X - 1;
 end;

if IsKeyDown(KEY_A) and (player.pos.X < (self.pos1.X + 60)) then
 begin
 pos1.X := pos1.X - 1;
 pos2.X := pos2.X - 1 ;
 cam.Offset.X := cam.Offset.X + 1;
 end;

if IsKeyDown(KEY_W) and (player.pos.Y < (posreal.Y + 60)) then
 begin
 pos1.Y := pos1.Y - 1;
 pos2.Y := pos2.Y - 1 ;
 posreal.Y := posreal.Y - 1;
 cam.Offset.Y := cam.Offset.Y + 1;
 end;

if IsKeyDown(KEY_S) and (player.pos.Y > (posreal.Y + 240)) then
 begin
 pos1.Y := pos1.Y + 1;
 pos2.Y := pos2.Y + 1 ;
 posreal.Y := posreal.Y + 1;
 cam.Offset.Y := cam.Offset.Y - 1;
 end;



end;


end.
