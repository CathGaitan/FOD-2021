program CrearBinarioMaestro;
type
    producto=record
        cod:integer;
        nombre:String[20];
        stockDisp:integer;
        stockMin:integer;
        precio:real;
    end;
    maestro = file of producto;

{----------------------------------------------------------------------}

procedure LeerProducto(var p:producto);
begin
    writeln('----PRODUCTO-----');
    write('Codigo: ');
    readln(p.cod);
    if (p.cod <> 9999) then begin
        write('Nombre: ');
        readln(p.nombre);
        write('Stock disponible: ');
        readln(p.stockDisp);
        write('Stock minimo: ');
        readln(p.stockMin);
        write('Precio: ');
        readln(p.precio);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    p:producto;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerProducto(p);
    while (p.cod <> 9999) do begin
        write(archivoMaestro,p);
        LeerProducto(p);
    end;
    close(archivoMaestro);
end.