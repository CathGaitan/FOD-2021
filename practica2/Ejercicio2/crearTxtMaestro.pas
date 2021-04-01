program CrearTxtMaestro;
type
    registro = record
        cod:integer;
        nombre:string[20];
        apellido:string[20];
        cursadas:integer;
        finales:integer;
    end;

{------------------------------------------------------------------------}

procedure LeerAlumno(var r:registro);
begin
    writeln('----ALUMNO----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Apellido: ');
        readln(r.apellido);
        write('Cursadas aprobadas: ');
        readln(r.cursadas);
        write('Finales aprobados: ');
        readln(r.finales);
    end;
end;

{------------------------------------------------------------------------}

procedure CrearTxt();
var
    texto:Text;
    r:registro;
begin
    Assign(texto,'alumnos');
    rewrite(texto);
    LeerAlumno(r);
    while (r.cod <> -1) do begin
        with r do begin
            writeln(texto,' ',cod,' ',cursadas,' ',finales,' ',nombre);
            writeln(texto,' ',apellido);
        end;
        LeerAlumno(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.