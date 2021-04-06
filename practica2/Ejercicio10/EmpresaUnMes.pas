{Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por división,
y por último, por número de empleado. Presentar en pantalla un listado}
program EmpresaUnMes;
const
    valoralto=9999;
type
    horas=record
        categoria:integer;
        precio:real;
    end;
    empleado=record
        departamento:integer;
        division:integer;
        numEmpleado:integer;
        categoria:1..15;
        cantHorasExtra:integer;
    end;
    maestro=file of empleado;
    vec=array[1..15] of real; //precio de horaExtra dependiendo categoria

{---------------------------------------------------------------}

procedure CargarVector(var vector:vec);
var
    texto:text;
    h:horas;
    i:integer;
begin
    assign(texto,'txtConPrecioExtra');
    reset(texto);
    for i:=1 to 15 do begin
        read(texto,h.categoria,h.precio);
        vector[h.categoria]:=h.precio;
    end;
    close(texto);
end;
{---------------------------------------------------------------}

procedure leer (var archivo:maestro;var dato:empleado);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.departamento:=valoralto;
end;
{---------------------------------------------------------------}

procedure ImprimirDatos(var mae:maestro; vector:vec);
var
    e:empleado;
    dep,divi,numemp:integer;
    horasdep,horasdivi,horasemp:integer;
    montodep,montodivi,montoemp:real;
begin
    leer(mae,e);
    while(e.departamento <> valoralto) do begin
        writeln('------------------------------');
        writeln('      Departamento ',e.departamento);
        dep:=e.departamento;
        horasdep:=0;
        montodep:=0;
        while(dep = e.departamento) do begin
            writeln('---Division ',e.division,'---');
            horasdivi:=0;
            montodivi:=0;
            divi:=e.division;
            while((dep=e.departamento) and (divi=e.division)) do begin
                writeln('Empleado ',e.numEmpleado);
                horasemp:=0;
                montoemp:=0;
                numemp:=e.numEmpleado;
                while((dep=e.departamento) and (divi=e.division) and (numemp=e.numEmpleado)) do begin
                    horasemp:=horasemp+e.cantHorasExtra;
                    montoemp:=montoemp+(e.cantHorasExtra*vector[e.categoria]);
                    Leer(mae,e);
                end;
                writeln('Total horas extras: ',horasemp);
                writeln('Importe a cobrar: ',montoemp:5:2);
                horasdivi:=horasdivi+horasemp;
                montodivi:=montodivi+montoemp;
            end;
            writeln('Total de horas division: ',horasdivi);
            writeln('Monto total division: ',montodivi:5:2);
            horasdep:=horasdep+horasdivi;
            montodep:=montodep+montodivi;    
        end;
        writeln('Total de horas departamento: ',horasdep);
        writeln('Monto total departamento: ',montodep:5:2);
   end;
end;
{---------------------------------------------------------------}
var
    mae:maestro;
    vector:vec;
begin
    assign(mae,'maestro');
    reset(mae);
    CargarVector(vector);
    ImprimirDatos(mae,vector);
    close(mae);
end.
