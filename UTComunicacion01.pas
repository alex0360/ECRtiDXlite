unit UTComunicacion01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, IdGlobal,
  IdTCPConnection, IdContext, IdTCPClient, IdBaseComponent, IdCustomTCPServer,
  IdTCPServer;

type
  TComunicacion01 = class(TObject)
  private
  public
  var IPLocal: String; PuertoLocal: Integer; IPRemota: String; PuertoRemoto: Integer;
  trama: string;
    constructor Create(_IPLocal: String; _PuertoLocal: Integer; _IPRemota: String;
      _PuertoRemoto: Integer);
    function Enquire(): String;
    function Synchronous(): String;
    function ECRPOS(): Boolean;
    procedure EnviarRecibirPOS();
    procedure TcpConnect(AContext: TIdContext);
    procedure TcpDisconnect(AContext: TIdContext);
    procedure TcpExecute(AContext: TIdContext);

  const
    ENQ: string = '';
    SYN: string = '';
    ACK: string = '';
    EM: string = '';
    EOT: string = '';
    FS: string = '';

  var
    ServidorCliente: TIdTCPServer;
    ClienteServidor: TIdTCPClient;
  end;

implementation

{ TComunicacion01 }

constructor TComunicacion01.Create(_IPLocal: String; _PuertoLocal: Integer;
  _IPRemota: String; _PuertoRemoto: Integer);
var
  time: Integer;
begin
  inherited Create;
  time := 30789;
  IPLocal:= _IPLocal; PuertoLocal:= _PuertoLocal;
  IPRemota:= _IPRemota; PuertoRemoto:= _PuertoRemoto;


  Writeln(IPLocal+':'+PuertoLocal.ToString+'<->' +IPRemota+':'+PuertoRemoto.ToString);

  ClienteServidor := TIdTCPClient.Create(nil);
  ClienteServidor.ReadTimeout := time;
  ClienteServidor.ConnectTimeout := time;

  ClienteServidor.Host := IPRemota; // IP para comunicar con el POS
  ClienteServidor.Port := PuertoRemoto; // Puerto para Comunicar con el POS

  //ServidorCliente := TIdTCPServer.Create;
  //ServidorCliente.ListenQueue := 5;
  //ServidorCliente.MaxConnections := 3; // Numero de Conexiones Maximas
  //ServidorCliente.DefaultPort := 7060; // Puerto para el Servidor
end;

function TComunicacion01.ECRPOS: Boolean;
var
  data: string;
  dataChar: char;
  bytes: Byte;
begin
  WriteLn('adderings-server!');
  ServidorCliente :=TIdTCPServer.Create;
  ServidorCliente.OnConnect:=TcpConnect;
  ServidorCliente.OnExecute:=TcpExecute;
  ServidorCliente.OnDisconnect:=TcpDisconnect;
  ServidorCliente.Bindings.Clear;
  ServidorCliente.Bindings.Add.SetBinding(IPLocal, PuertoLocal, Id_IPv4);
  ServidorCliente.StartListening;
  ServidorCliente.Active:=True;
end;

function TComunicacion01.Enquire: String;
var
  buffer: string;
begin
  ClienteServidor.Connect;
  Writeln('Enquire-> '+ ENQ);
  ClienteServidor.Socket.Write(ENQ);
  buffer := ClienteServidor.Socket.ReadChar;
  Writeln('Enquire<- '+ buffer);
  ClienteServidor.Disconnect;
  if buffer = ACK then
  begin
    Result := ACK;
  end
  else
  begin
    Result := 'Error Enquire';
  end;
end;

procedure TComunicacion01.EnviarRecibirPOS;
begin
  if Enquire = ACK then
  begin
    if Synchronous = EM then
    begin
      Writeln(true);
      ECRPOS();
    end;
  end;
end;

function TComunicacion01.Synchronous: String;
var
  buffer: string;
begin
  ClienteServidor.Connect;
  Writeln('Synchronous-> '+ SYN);
  ClienteServidor.Socket.Write(SYN);
  buffer := ClienteServidor.Socket.ReadChar;
  Writeln('Synchronous<- ' + buffer);
  ClienteServidor.Disconnect;
  if buffer = EM then
  begin
    Result := EM;
  end
  else
  begin
    Result := 'Error Synchronous';
  end;
end;

procedure TComunicacion01.TcpConnect(AContext: TIdContext);
begin
  Writeln('Hola Mundo');
  with AContext.Binding do
    Writeln('Client connected from ', PeerIP, ':', PeerPort);
end;

procedure TComunicacion01.TcpDisconnect(AContext: TIdContext);
begin
  Writeln('Client disconnected');
end;

procedure TComunicacion01.TcpExecute(AContext: TIdContext);
var
num: integer;
buffer: string;
Bytes: TBytes;
begin
  trama:='CN00000000000118000000000018000000000000000002';
  WriteLn('Execute');
  num:=1;
  try
  while True do
  begin
    buffer:= AContext.Connection.Socket.ReadChar;
    Writeln('Execute<-' + buffer);
    if buffer = ENQ then
    begin
    writeln('Execute-> ' + trama);
    AContext.Connection.IOHandler.Write(trama);
    repeat
       buffer:= AContext.Connection.Socket.ReadChar;
       // Write(buffer);
       //AContext.Connection.IOHandler.ReadBytes(Bytes[-1]);
       //buffer := BytesToString(Bytes);
       Write(buffer);
    until (True);

    end;

   Writeln('While '+ num.ToString);
   //writeln('Execute-> ' + ACK);
   //AContext.Connection.IOHandler.Write(ACK);
   num:=num+1;
  end;

  except
   on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
  //AContext.Connection.Disconnect
end;
end.
