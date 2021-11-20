unit uDMServer;

interface

uses
  System.SysUtils, System.Classes, Vcl.ExtCtrls, System.Win.ScktComp,
  uCtrl_Conexoes;

type
  TDMServer = class(TDataModule)
    tLatencia: TTimer;
    procedure tLatenciaTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    ssPrincipal: TServerSocket;
    FConexoes: TConexoes;
    procedure ssPrincipalClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ssPrincipalClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    function GetConexoes: TConexoes;
  public
    property Conexoes: TConexoes read GetConexoes;
  end;

var
  DMServer: TDMServer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}


uses uConstants, uCtrl_ThreadsService, Winapi.Windows;

{$R *.dfm}

{ TDM_Server }

procedure TDMServer.DataModuleCreate(Sender: TObject);
begin
  tLatencia.Enabled := True;
  ssPrincipal := TServerSocket.Create(self);
  ssPrincipal.Active := False;
  ssPrincipal.ServerType := stNonBlocking;
  ssPrincipal.OnClientConnect := ssPrincipalClientConnect;
  ssPrincipal.OnClientError := ssPrincipalClientError;
  ssPrincipal.Port := PORTA;
  ssPrincipal.Active := True;
end;

procedure TDMServer.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FConexoes) then
    FreeAndNil(FConexoes);
  if Assigned(ssPrincipal) then
  begin
    ssPrincipal.Active := False;
    FreeAndNil(ssPrincipal);
  end;
  tLatencia.Enabled := False;
end;

function TDMServer.GetConexoes: TConexoes;
begin
  if not Assigned(FConexoes) then
    FConexoes := TConexoes.Create;
  Result := FConexoes;
end;

procedure TDMServer.ssPrincipalClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  TThreadConexaoDefinidor.Create(Socket);
end;

procedure TDMServer.ssPrincipalClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TDMServer.tLatenciaTimer(Sender: TObject);
var
  Conexao: TConexao;
begin
  for Conexao in Conexoes.ListaConexoes do
    Conexao.Ping;
end;

end.