program CrearArchivoAves;
type
    ave=record
        cod:integer;
        nombre:string[50];
        zonaGeografica:string[50];
    end;
    archivoAves=file of ave;

{--------------------------------------------------------------}
procedure LeerAve(var a:ave);
begin
    writeln('----AVE-----');
    write('Codigo: ');
    readln(a.cod);
    if (a.cod <> 9999) then begin
        write('Nombre: ');
        readln(a.nombre);
        write('Zona geografica: ');
        readln(a.zonaGeografica);
    end;
end;

{---------------------------------------------------------}
var
    archivo:archivoAves;
    a:ave;
begin
    assign(archivo,'archivoAves');
    Rewrite(archivo);
    LeerAve(a);
    while (a.cod <> 9999) do begin
        write(archivo,a);
        LeerAve(a);
    end;
    close(archivo);
end.