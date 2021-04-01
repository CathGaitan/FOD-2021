program CrearTXTMaestro;
type
    producto=record  ///REGISTRO MAESTRO
        cod:integer;
        nombre:String[20];
        precio:real;
        stockAct:integer;
        stockMin:integer;
    end;

{------------------------------------------------------------------------}

procedure LeerProducto(var r:producto);
begin
    writeln('----PRODUCTO----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> 9999) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Precio: ');
        readln(r.precio);
        write('Stock actual: ');
        readln(r.stockAct);
        write('Stock minimo: ');
        readln(r.stockMin);
    end;
end;

{------------------------------------------------------------------------}

procedure CrearTxt();
var
    texto:Text;
    r:producto;
begin
    Assign(texto,'productos');
    rewrite(texto);
    LeerProducto(r);
    while (r.cod <> 9999) do begin
        with r do begin
            writeln(texto,' ',cod,' ',nombre);
            writeln(texto,' ',stockAct,' ',stockMin,' ',precio:5:2);
        end;
        LeerProducto(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.