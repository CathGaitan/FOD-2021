program CrearBinarioMaestro;
const
    valoralto=9999;
type
    mesas=record
        codprov:integer;
        codlocal:integer;
        numMesa:integer;
        cantVotos:integer;
    end;
    maestro=file of mesas;
{----------------------------------------------------------------------}

procedure LeerMesa(var m:mesas);
begin
    writeln('----PRODUCTO-----');
    write('Codigo provincia: ');
    readln(m.codprov);
    if (m.codprov <> 9999) then begin
        write('Codigo Localidad ');
        readln(m.codlocal);
        write('Numero mesa: ');
        readln(m.numMesa);
        write('Cantidad de votos: ');
        readln(m.cantVotos);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    m:mesas;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerMesa(m);
    while (m.codprov <> 9999) do begin
        write(archivoMaestro,m);
        LeerMesa(m);
    end;
    close(archivoMaestro);
end.