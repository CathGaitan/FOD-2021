program CrearBinarioMaestro;
type
    regMaestro=record
        prov:String[20];
        alfabetizados:integer;
        encuestados:integer;
    end;
    maestro = file of regMaestro;

{----------------------------------------------------------------------}

procedure LeerCenso(var r:regMaestro);
begin
    writeln('----CENSO-----');
    write('Provincia: ');
    readln(r.prov);
    if (r.prov <> 'ZZZZ') then begin
        write('Cantidad de gente alfabetizada: ');
        readln(r.alfabetizados);
        write('Cantidad de gente encuestada: ');
        readln(r.encuestados);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    r:regMaestro;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerCenso(r);
    while (r.prov <> 'ZZZZ') do begin
        write(archivoMaestro,r);
        LeerCenso(r);
    end;
    close(archivoMaestro);
end.