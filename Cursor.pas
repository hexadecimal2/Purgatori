unit Cursor;

interface

uses
Raylib, Game;

type
TCursor = class(TObject)

public
pos : TVector2;

constructor Create(game : TGame);
procedure Render(game : TGame; cam : TCamera2D);
procedure Update();


private


sprite: TTexture;

end;

implementation

{ TCursor }

constructor TCursor.Create(game: TGame);
begin

 self.pos := GetMousePosition;
 self.sprite := game.textures['cursor'];
end;

procedure TCursor.Render(game : TGame; cam : TCamera2D);
begin

DrawTexturePro(self.sprite,
TRectangle.Create(0,0,9,9),
TRectangle.Create(pos.X - cam.Offset.X, pos.Y - cam.Offset.Y, 9,9),
TVector2.Create(4.5,4.5),
0,
WHITE
);

DrawText(TextFormat('mouse pos x: %f', pos.X ), 10, 40, 10, BLACK);
DrawText(TextFormat('mouse pos y: %f', pos.Y ), 10, 50, 10, BLACK);

end;

procedure TCursor.Update();
begin

 pos.X := (GetMouseX / 2) - 2 ;
 pos.Y := (GetMouseY / 2) - 2 ;

end;

end.
