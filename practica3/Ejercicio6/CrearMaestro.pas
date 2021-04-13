program CrearMaestro;
type
    prenda=record
        cod:integer;
        descripcion:string[50];
        stock:integer;
        precio:real;
    end;
    archivoPrenda=file of prenda;
{---------------------------------------------------------}

procedure LeerPrenda(var p:prenda);
begin
    writeln('----PRENDA-----');
    write('Codigo: ');
    readln(p.cod);
    if (p.cod <> 9999) then begin
        write('Descripcion: ');
        readln(p.descripcion);
        write('Stock: ');
        readln(p.stock);
        write('Precio: ');
        readln(p.precio);
    end;
end;

{---------------------------------------------------------}
var
    ArchivoMaestro:archivoPrenda;
    p:prenda;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerPrenda(p);
    while (p.cod <> 9999) do begin
        write(archivoMaestro,p);
        LeerPrenda(p);
    end;
    close(archivoMaestro);
end.