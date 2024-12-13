unit Bat;

interface
{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}
uses Raylib,
Raymath,
Game,
Player,
Bullet,
Generics.Collections,
Animations;

type
sprite_direction = (left, right);

TBat = class(TObject)

public
sprite : TTexture;
pos : TVector2;
hitbox : TRectangle;

constructor Create(Game : TGame; pos : TVector2);
procedure Render(Game : TGame);
procedure Update(Player : TPlayer; Bats : TList<TBat>; Bullets : TList<TBullet>);

private

sprite_size : TVector2;
direction : TVector2;
render_direction : sprite_direction;
animations : TAnimations;

idle, hit : boolean;

end;


implementation


{ TGhost }

constructor TBat.Create(game : TGame; pos : TVector2);
begin

self.sprite := game.textures['bat_idle'];
self.pos := pos;
self.hitbox := TRectangle.Create(self.pos.x, self.pos.y, 16 , 16);

self.sprite_size := TVector2.Create(32,32);

idle := true;
hit := false;

self.animations := TAnimations.Create(Game);
self.animations.LoadAnimation('idle', 6, 0.1, true, self.sprite);
self.animations.LoadAnimation('hit', 4, 0.1, false, game.textures['bat_hit']);
end;

procedure TBat.Render(game : TGame);
begin

if idle then
begin
self.animations.PlayAnimation('idle', self.pos, self.sprite_size);
end
else
if hit then
begin                                                                      //state machine woohoo
  self.animations.PlayAnimation('hit', self.pos, self.sprite_size);

  if self.animations.IsAnimationFinished('hit') then
  begin
    idle := true;
    hit := false;
  end;

end;

 if boolean(game.debug_mode) then
 begin
   DrawRectangleRec(hitbox,TColor.Create(255,0,0,100));
 end;


end;

procedure TBat.Update(player : TPlayer; Bats : TList<TBat>; Bullets : TList<TBullet>);
var
bullet : TBullet;
begin

 if IsKeyPressed(KEY_L) then
 begin
   idle := true;                              //state machine
   hit := false;
 end;

 if IsKeyPressed(KEY_SEMICOLON) then
 begin
   hit := true;
   idle := false;
 end;

 self.direction.X := player.pos.X - self.pos.X;
 self.direction.Y := player.pos.Y - self.pos.Y;

 if direction.X > 0 then
 begin
 self.render_direction := left;
 end
 else if direction.X < 0 then
 begin
 self.render_direction := right;
 end;

 self.direction := Vector2Normalize(direction);

 pos.X := pos.X + direction.X * 0.8;
 pos.Y := pos.Y + direction.Y * 0.8;

 case render_direction of
 left :  begin
         self.sprite_size.X := -32;
         end;
 right : begin
         self.sprite_size.X := 32;
         end;
 end;


 self.hitbox.X := self.pos.X - 8;
 self.hitbox.Y := self.pos.Y - 8;

  for bullet in Bullets do
 begin
   if CheckCollisionRecs(self.hitbox, bullet.hitbox) then
   begin
     self.Free;
     bats.Remove(self);
     bullet.Free;
     bullets.Remove(bullet);
   end;

 end;

end;

end.
