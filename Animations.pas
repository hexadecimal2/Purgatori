unit Animations;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  Raylib,
  Generics.Collections,
  Game;

type

  { TAnimation }

  TAnimation = class(TObject)

  private

    spritesheet: TTexture;
    animation_frames: integer;
    animation_speed: single;
    looping: boolean;

    frame: integer;
    timer, frametime: real;

    pos: TVector2;

    constructor Create(animation_name: string; animation_frames: integer;
      looping: boolean; spritesheet: TTexture);

  end;

  { TAnimations }

  TAnimations = class(TObject)

  public

    Animations: TDictionary<string, TAnimation>;

    constructor Create(Game: TGame);
    procedure LoadAnimation(animation_name: string; animation_frames: integer;
      animation_speed: single; looping: boolean; spritesheet: TTexture);
    procedure PlayAnimation(animation_name: string; pos, sprite_size: TVector2);

    function IsAnimationFinished(animation_name: string): boolean;
    function IsAnimationPlaying(animation_name: string): boolean;

  private

  end;

implementation

{ TAnimation }

constructor TAnimation.Create(animation_name: string; animation_frames: integer;
  looping: boolean; spritesheet: TTexture);
begin
  self.frame := 0;

  self.spritesheet := spritesheet;
  self.animation_frames := animation_frames;
  self.looping := looping;

end;

{ TAnimations }

constructor TAnimations.Create(Game: TGame);
begin

  self.Animations := TDictionary<string, TAnimation>.Create;

end;

procedure TAnimations.LoadAnimation(animation_name: string;
  animation_frames: integer; animation_speed: single; looping: boolean;
  spritesheet: TTexture);

var
  anim: TAnimation;

begin

  anim := TAnimation.Create(animation_name, animation_frames, looping,
    spritesheet);
  anim.frametime := animation_speed * 60 / 60;
  anim.timer := anim.frametime;
  self.Animations.Add(animation_name, anim);

end;

procedure TAnimations.PlayAnimation(animation_name: string;
  pos, sprite_size: TVector2);

var
  anim: TAnimation;
begin

  anim := self.Animations[animation_name];

  if IsAnimationFinished(animation_name) then
  begin
    anim.frame := 0;
    Exit;

  end
  else

  //if not IsAnimationFinished(animation_name) then
  begin

    if anim.timer > 0 then
    begin
      anim.timer := anim.timer - GetFrameTime();


    if anim.timer <= 0 then
    begin
      anim.frame := anim.frame + 1;
      anim.timer := anim.frametime;
    end;

    if anim.looping = true then
    begin
      if anim.frame > anim.animation_frames - 1 then
      begin
        anim.frame := 0;
      end
    end
    else
    begin
      if anim.frame >= anim.animation_frames - 1 then
      begin
        anim.frame := anim.animation_frames - 1;
      end;
    end;

      anim.pos.X := pos.X;
      anim.pos.Y := pos.Y;

      DrawTexturePro(self.Animations[animation_name].spritesheet,
        TRectangle.Create(anim.frame * anim.spritesheet.Width /
        anim.animation_frames, 0, sprite_size.X, sprite_size.Y),
        TRectangle.Create(pos.X, pos.Y, 16, 16), TVector2.Create(8, 8),
        0, WHITE);

    end
  end;
end;

function TAnimations.IsAnimationFinished(animation_name: string): boolean;
var
  anim: TAnimation;
begin

  anim := self.Animations[animation_name];

  if (anim.frame >= anim.animation_frames - 1) and (anim.looping = false) then
  begin
    WriteLn('finished!');
    result := true;
  end
  else
  result := false;

end;

function TAnimations.IsAnimationPlaying(animation_name: string): boolean;
var
  anim: TAnimation;
begin

  anim := self.Animations[animation_name];

  if (anim.frame > 0) and (anim.frame < anim.animation_frames) then
  begin
    WriteLn('running!');
    result := true;
  end
  else
    result := false;

end;

end.
