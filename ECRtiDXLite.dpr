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
    comunicacion:= TComunicacion01.Create('10.0.0.2', 2018, '10.0.0.3', 7060);
    Writeln('{10.0.0.2}<->{10.0.0.3}');
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
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
