program CrearDetalle;
type
    correo=record
        nrousuario:integer;
        cuentaDestino:String[20];
        cuerpoMensaje:String[20];
    end;
    detalle=file of correo;
{----------------------------------------------------------------}

procedure LeerInfoCorreoEnviado(var c:correo);
begin
    WriteLn('---PRODUCTO DETALLE----');
    write('Numero de usuario: ');
    readln(c.nrousuario);
    if(c.nrousuario <> 9999) then begin
        write('Cuenta destino: ');
        readln(c.cuentaDestino);
        write('Cuerpo del mensaje: ');
        readln(c.cuerpoMensaje);
    end;
end;

{----------------------------------------------------------------}
var
    i:integer;
    iString:String;
    archivo:detalle;
    c:correo;
begin
    Assign(archivo,'detalle');
    rewrite(archivo); //creo mi detalle
    LeerInfoCorreoEnviado(c);
    while (c.nrousuario <> 9999) do begin
        write(archivo,c);
        LeerInfoCorreoEnviado(c);
    end;
        close(archivo);
end.