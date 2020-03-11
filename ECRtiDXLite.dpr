program ECRtiDXLite;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  UTComunicacion01 in 'UTComunicacion01.pas';

procedure _Comunicacion;
var
  comunicacion: TComunicacion01;
begin
    comunicacion:= TComunicacion01.Create('192.168.137.1', 2018, '192.168.137.2', 7060);
    comunicacion.EnviarRecibirPOS();
    comunicacion.Free;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
     _Comunicacion;
     Readln;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Readln;
    end;
  end;

end.
