program CrearBinarioDetalle;
type
    empleado=record
        cod:integer;
        nombre:string[20];
        monto:real;
    end;
    detalle=file of empleado;
{----------------------------------------------------------------}

procedure LeerProductoDetalle(var p:empleado);
begin
    WriteLn('---PRODUCTO DETALLE----');
    write('Codigo: ');
    readln(p.cod);
    if(p.cod <> 9999) then begin
        write('Nombre: ');
        readln(p.nombre);
        write('Monto: ');
        readln(p.monto);
    end;
end;

{----------------------------------------------------------------}
var
    i:integer;
    iString:String;
    archivo:detalle;
    p:empleado;
begin
    AssignFile(archivo,'detalle');
    rewrite(archivo); //creo mi detalle
    LeerProductoDetalle(p);
    while (p.cod <> 9999) do begin
        write(archivo,p);
        LeerProductoDetalle(p);
    end;
        close(archivo);
end.