program CrearArchivoTxt;
type
    registro = record
        cod:integer;
        nombre:String[20];
        descrip:String[20];
        marca:String[20];
        precio:real;
        stockmin:integer;
        stockdisp:integer;
    end;

{------------------------------------------------------------------------}

procedure LeerCelular(var r:registro);
begin
    writeln('----CELULAR----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Descripcion: ');
        readln(r.descrip);
        write('Marca: ');
        readln(r.marca);
        write('Precio: ');
        readln(r.precio);
        write('Stock minimo: ');
        readln(r.stockmin);
        write('Stock disponible: ');
        readln(r.stockdisp);
    end;
end;

{------------------------------------------------------------------------}

procedure CrearTxt();
var
    nombrefisico:String[20];
    texto:Text;
    r:registro;
begin
    write('Nombre que va a tener el txt: ');
    readln(nombrefisico);
    Assign(texto,nombrefisico);
    rewrite(texto);
    LeerCelular(r);
    while (r.cod <> -1) do begin
        with r do begin
            writeln(texto,' ',cod,' ',stockdisp,' ',stockmin,' ',precio:5:2,' ',nombre);
            writeln(texto,' ',descrip);
            writeln(texto,' ',marca);
        end;
        LeerCelular(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.