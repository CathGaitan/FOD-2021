program Empleados;
const
    valoralto=9999;
type
    empleado=record
        cod:integer;
        nombre:string[20];
        direccion:string[20];
        DNI:integer;
    end;

    archivoEmp=file of empleado;

{----------------------------------------------------------}
procedure Leer (var archivo:archivoEmp;var dato:empleado);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.cod:=valoralto;
end;
{----------------------------------------------------------}
procedure LeerEmpleado(var e:empleado);
begin
    writeln('---EMPLEADO----');
    write('DNI: ');
    readln(e.DNI);
    if (e.DNI <> valoralto) then begin
        write('Nombre: ');
        readln(e.nombre);
        write('Direccion: ');
        readln(e.direccion);
        write('Codigo: ');
        readln(e.cod);
    end;
end;
{----------------------------------------------------------}

procedure CrearArchivo();
var
    archivo:archivoEmp;
    e:empleado;
begin
    assign(archivo,'archivoDeEmpleados');
    Rewrite(archivo);
    LeerEmpleado(e);
    while (e.DNI <> 9999) do begin
        write(archivo,e);
        LeerEmpleado(e);
    end;
    close(archivo);
end;
{----------------------------------------------------------}

procedure BajaLogica();
var
    archivo:archivoEmp;
    reg:empleado;
    dimL,i:integer;
begin
    writeln('ELIMINANDO REGISTROS CON DNI MENOR A 900');
    assign(archivo,'archivoDeEmpleados');
    reset(archivo);
    leer(archivo,reg);
    while(reg.cod <>valoralto) do begin
        if (reg.DNI < 900) then begin
            reg.nombre:='***';
            seek(archivo,filepos(archivo)-1);
            write(archivo,reg);
        end;
        leer(archivo,reg);
    end;
    close(archivo);
end;

{----------------------------------------------------------}
procedure ExportarATxt();
var
    texto:Text;
    r:empleado;
    archivo:archivoEmp;
    nom:string[20];
begin
    assign(archivo,'archivoDeEmpleados');
    reset(archivo); //abro mi archivo binario
    write('Nombre que va a tener el txt: ');
    readln(nom);
    assign(texto,nom);
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivo)) do begin
        read(archivo,r);
        with r do begin
          writeln(texto,' cod: ',cod,' Nombre: ',nombre);
          writeln(texto,' DNI: ',DNI);
        end;
    end;
    close(texto);
    close(archivo);
end;
{----------------------------------------------------------}
begin
    CrearArchivo();
    ExportarATxt();
    BajaLogica();
    ExportarATxt();
end.