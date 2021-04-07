program CrearMaestro;
type
    logs=record
        nrousuario:integer;
        nombreUsuario:String[20];
        nombre:String[20];
        apellido:String[20];
        cantidadMailEnviados:integer;
    end;
    maestro=file of logs;

{----------------------------------------------------------------------}

procedure LeerLogs(var l:logs);
begin
    writeln('----LOGEOS-----');
    write('Numero de usuario: ');
    readln(l.nrousuario);
    if (l.nrousuario <> 9999) then begin
        write('Nombre usuario: ');
        readln(l.nombreUsuario);
        write('Nombre: ');
        readln(l.nombre);
        write('Apellido: ');
        readln(l.apellido);
        write('Cantidad de mails enviados: ');
        readln(l.cantidadMailEnviados);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    l:logs;
begin
    assign(archivoMaestro,'logmail');
    Rewrite(archivoMaestro);
    LeerLogs(l);
    while (l.nrousuario <> 9999) do begin
        write(archivoMaestro,l);
        LeerLogs(l);
    end;
    close(archivoMaestro);
end.