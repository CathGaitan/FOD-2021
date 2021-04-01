program CrearTxtDetalle;
type
    registro = record
        cod:integer;
        aprobo:integer; 
    end;

{------------------------------------------------------------------------}

procedure LeerAlumno(var r:registro);
begin
    writeln('----ALUMNO DETALLE----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Que aprobo?(0=Cursada 1=Final): ');
        readln(r.aprobo);
    end;
end;

{------------------------------------------------------------------------}

procedure CrearTxt();
var
    texto:Text;
    r:registro;
begin
    Assign(texto,'detalle');
    rewrite(texto);
    LeerAlumno(r);
    while (r.cod <> -1) do begin
        with r do begin
            writeln(texto,' ',cod,' ',aprobo);
        end;
        LeerAlumno(r);
    end;
    close(texto);
end;

{------------------------------------------------------------------------}
begin
    CrearTxt();
end.