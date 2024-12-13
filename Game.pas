

unit Game;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}

interface

uses
  SysUtils,
  raylib,
  raymath,
  Generics.Collections;

type

  TGame = class(TObject)

  public

    textures: TDictionary<string, TTexture>;
    debug_mode : Integer;

    procedure Main();
    constructor Create();

  private

  end;

  PGame = ^TGame;

implementation

uses
  Player, Gun, Cursor, Bullet, Background, Bat, Animations;

var

  DisplayRect, ScreenRect : TRectangle;

  DisplayTexture: TRenderTexture2D;
  Player: TPlayer;
  Gun : TGun;
  Cursor : TCursor;
  Bullets : TList<TBullet>;
  Bats : TList<TBat>;
  Background : TBackground;
  Camera : TCamera2D;

  WindowScale : TVector2;


const
  ScreenWidth = 800;
  ScreenHeight = 600;

  // Program main entry point
constructor TGame.Create;
begin
  Main();
end;

procedure TGame.Main();
var
  song : TMusic;
  bullet : TBullet;
  bat : TBat;
  i : integer;
  begin
  // Initialization
  SetConfigFlags(FLAG_WINDOW_HIGHDPI);

  InitWindow(ScreenWidth, ScreenHeight, UTF8String('Purgatori'));
  InitAudioDevice;

  SetTextureFilter(GetFontDefault().Texture, TEXTURE_FILTER_POINT);

  DisplayTexture := LoadRenderTexture(400, 300);
  WindowScale := TVector2.Create(2,2);

  DisplayRect := TRectangle.Create(0,0, DisplayTexture.Texture.width, -DisplayTexture.Texture.height);
  ScreenRect := TRectangle.Create(DisplayTexture.Texture.Width / 2, DisplayTexture.Texture.Height / 2, DisplayTexture.Texture.Width * WindowScale.X, DisplayTexture.Texture.Height * WindowScale.Y);





  song := LoadMusicStream('music/song.mp3');

  SeekMusicStream(song, 9);
  SetMusicPitch(song, 1);
  SetMusicVolume(song, 0.4);
  PlayMusicStream(song);

  debug_mode := 0;

  SetTargetFPS(60); // Set 60 frames-per-second

  DisableCursor;

  bullets := TList<TBullet>.Create;
  bats := TList<TBat>.Create;



  Camera := TCamera2D.Create(TVector2.Create(0,0), TVector2.Create(0,0), 0, 1);

  textures := TDictionary<string, TTexture>.Create;

  //sprites
  textures.Add('gun', LoadTexture('sprites/player/gun.png'));
  textures.Add('cursor', LoadTexture('sprites/other/cursor.png'));
  textures.Add('background', LoadTexture('bg/background.png'));

  //animations
  textures.Add('player_idle', LoadTexture('sprites/player/player_idle.png'));
  textures.Add('bat_idle', LoadTexture('sprites/enemies/bat_move.png'));
  textures.Add('bat_hit', LoadTexture('sprites/enemies/bat_hit.png'));


  Background := TBackground.Create(self, 70);

  Player := TPlayer.Create(self, TVector2.Create(200, 150));
  Gun := TGun.Create(self, Player, 6);
  Cursor := TCursor.Create(self);

  for i := 1 to 1 do
  begin
    Bats.Add(TBat.Create(self, TVector2.Create(GetRandomValue(0, 400), GetRandomValue(0,300))));
  end;



  // Main loop
  while not WindowShouldClose() do
  begin
    // Update

    if IsKeyPressed(KEY_F) then
    begin

      SetMousePosition(0,0);

      SetWindowSize(GetMonitorWidth(GetCurrentMonitor()), GetMonitorHeight(GetCurrentMonitor()));

      ScreenRect.Width := GetMonitorWidth(GetCurrentMonitor());
      ScreenRect.Height := GetMonitorHeight(GetCurrentMonitor());
      ToggleFullscreen;

    end;



    if not IsWindowFullscreen() then
    begin
      SetWindowSize(ScreenWidth, ScreenHeight);

      ScreenRect.Width := ScreenWidth;
      ScreenRect.Height := ScreenHeight;

    end;

    UpdateMusicStream(song);

    if IsKeyPressed(KEY_TAB) then
    begin
      debug_mode := debug_mode + 1;
      if debug_mode > 1 then
      begin
      debug_mode := 0;
      end
      else
      if debug_mode < 0 then
      begin
      debug_mode := 1;
    end;
    end;


    Background.Update(self, Player, Camera);
    Player.Update;
    Gun.Update(Player, Camera);
    Cursor.Update;

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
    begin
      Bullets.Add(TBullet.Create(self, gun, camera));
    end;


    for bullet in Bullets do
    begin
      bullet.Update(self, gun, Bullets, Background, Player);
    end;

    for bat in Bats do
    begin
      bat.Update(Player,bats, bullets);
    end;


    // Draw
    BeginTextureMode(DisplayTexture);
    // render everthing to the texture for upscaling

    BeginMode2D(Camera);

    ClearBackground(WHITE);

    Background.Render(self);
    Player.Render(self);
    Gun.Render(self);


    Cursor.Render(self, camera);

    for bullet in Bullets do
      begin
       bullet.Render(self);
      end;

    for bat in Bats do
    begin
      bat.Render(self);
    end;

    EndMode2D;

    EndTextureMode;


    BeginDrawing();


    ClearBackground(BLANK);


    // upscale render texture
    DrawTexturePro(DisplayTexture.Texture,
    DisplayRect, // source
    ScreenRect, //destination

    TVector2.Create(DisplayTexture.Texture.Width / 2,DisplayTexture.Texture.Height / 2),
    0,
    WHITE);

    DrawText(TextFormat('debug_mode: %d' , debug_mode), 650, 10,20, GREEN);


    if boolean(debug_mode) then
    begin
      DrawText(TextFormat('bullets : %d', Bullets.Count), 10, 120, 20, BLACK);
      DrawText(TextFormat('number of bats: %d', Bats.Count) , 10, 140, 20, YELLOW);
    end;

    EndDrawing();

  end;

  // De-Initialization
  CloseWindow();
  CloseAudioDevice();

  end;

end.
