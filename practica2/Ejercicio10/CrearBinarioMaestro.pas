program CrearBinarioMaestro;
const
    valoralto=9999;
type
    empleado=record
        departamento:integer;
        division:integer;
        numEmpleado:integer;
        categoria:1..15;
        cantHorasExtra:integer;
    end;
    maestro=file of empleado;
{----------------------------------------------------------------------}

procedure LeerEmpleado(var e:empleado);
begin
    writeln('----EMPLEADO-----');
    write('Departamento: ');
    readln(e.departamento);
    if (e.departamento <> valoralto) then begin
        write('Division: ');
        readln(e.division);
        write('Numero empleado: ');
        readln(e.numEmpleado);
        write('Categoria: ');
        readln(e.categoria);
        write('Cantidad de horas extras: ');
        readln(e.cantHorasExtra);
    end;
end;

{----------------------------------------------------------------------}
var
    ArchivoMaestro:maestro;
    e:empleado;
begin
    assign(archivoMaestro,'maestro');
    Rewrite(archivoMaestro);
    LeerEmpleado(e);
    while (e.departamento <> 9999) do begin
        write(archivoMaestro,e);
        LeerEmpleado(e);
    end;
    close(archivoMaestro);
end.