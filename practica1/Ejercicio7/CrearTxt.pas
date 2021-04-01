program CrearTxt;
type
    registro = record
        cod:integer;
        nombre:String[20];
        genero:String[20];
        precio:real;
    end;

{------------------------------------------------------------------------}

procedure LeerNovela(var r:registro);
begin
    writeln('----NOVELA----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Genero: ');
        readln(r.genero);
        write('Precio: ');
        readln(r.precio);
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
    LeerNovela(r);
    while (r.cod <> -1) do begin
        with r do begin
            writeln(texto,' ',cod,' ',precio:5:2,' ',' ',genero);
            writeln(texto,' ',nombre);
        end;
        LeerNovela(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.