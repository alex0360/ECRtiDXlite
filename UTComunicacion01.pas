unit UTComunicacion01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  IdTCPConnection, IdTCPClient, IdBaseComponent, IdCustomTCPServer,
  IdTCPServer;

type
  TComunicacion01 = class(TObject)
  private
  public
  constructor Create(IPLocal: String; PuertoLocal: Integer; IPRemota: String; PuertoRemoto: Integer);
  function Enquire():String;
  function Synchronous():String;
  procedure EnviarRecibirPOS();
  function ECRPOS():Boolean;
  const
      ENQ : string = '';
      SYN : string = '';
      ACK : string = '';
      EM  : string = '';
      EOT : string = '';
      FS  : string = '';

  var
    ServidorCliente: TIdTCPServer;
    ClienteServidor: TIdTCPClient;
  end;

implementation

{ TComunicacion01 }

constructor TComunicacion01.Create(IPLocal: String; PuertoLocal: Integer;
  IPRemota: String; PuertoRemoto: Integer);
  var
   time: Integer;
begin
    inherited Create;
    time:= 30789;

    ClienteServidor:= TIdTCPClient.Create(nil);
    ClienteServidor.ReadTimeout := time;
    ClienteServidor.ConnectTimeout := time;

    ClienteServidor.Host := IPRemota; // IP para comunicar con el POS
    ClienteServidor.Port := PuertoRemoto; // Puerto para Comunicar con el POS

    ServidorCliente:= TIdTCPServer.Create(nil);
    ServidorCliente.ListenQueue:= 5;
    ServidorCliente.MaxConnections:= 3; // Numero de Conexiones Maximas
    ServidorCliente.DefaultPort:= 7060; // Puerto para el Servidor

end;

function TComunicacion01.ECRPOS: Boolean;
var
  data: string;
  dataChar: char;
  bytes : Byte;
begin
    ServidorCliente.Active:=true;

end;

function TComunicacion01.Enquire: String;
var
  buffer: string;
begin
  ClienteServidor.Connect;
  ClienteServidor.Socket.Write(ENQ);
  buffer := ClienteServidor.Socket.ReadChar;
  ClienteServidor.Disconnect;
  if buffer = ACK then
  begin
    Result:= ACK;
  end
  else
  begin
    Result:= 'Error Enquire';
  end;
end;

procedure TComunicacion01.EnviarRecibirPOS;
begin
    if Enquire = ACK then
    begin
        if Synchronous = EM then
        begin
          Write(true);
        end;
    end;
end;

function TComunicacion01.Synchronous: String;
var
  buffer: string;
begin
  ClienteServidor.Connect;
  ClienteServidor.Socket.Write(SYN);
  buffer := ClienteServidor.Socket.ReadChar;
  ClienteServidor.Disconnect;
  if buffer = EM then
  begin
    Result:= EM;
  end
  else
  begin
    Result:= 'Error Synchronous';
  end;
end;

end.
