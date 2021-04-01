program CrearTXTDetalle;
type
    venta=record  //REGISTRO DETALLE
        cod:integer;
        cantVendida:integer;
    end;

{------------------------------------------------------------------------}

procedure LeerVenta(var r:venta);
begin
    writeln('----VENTA----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> 9999) then begin
        write('Cantidad vendida: ');
        readln(r.cantVendida);
    end;
end;

{------------------------------------------------------------------------}

procedure CrearTxt();
var
    texto:Text;
    r:venta;
begin
    Assign(texto,'ventas');
    rewrite(texto);
    LeerVenta(r);
    while (r.cod <> 9999) do begin
        with r do begin
            writeln(texto,' ',cod,' ',cantVendida);
        end;
        LeerVenta(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.