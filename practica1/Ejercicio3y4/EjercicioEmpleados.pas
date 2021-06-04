program EjercicioEmpleados;
type 
    registro = record
        num:integer;
        apellido:String[20];
        nombre:String[20];
        edad:integer;
        DNI:LongInt;
    end;

    archivo = file of registro;

{--------------------------------------------------------------------------}

procedure LeerEmpleado (var r:registro);
begin
    writeln('---EMPLEADO---');
    write('Apellido: ');
    readln(r.apellido);
    if (r.apellido <> 'fin') then begin
        write('Nombre: ');
        ReadLn(r.nombre);
        write('Numero empleado: ');
        readln(r.num);
        write('Edad: ');
        readln(r.edad);
        write('DNI: ');
        readln(r.dni);
    end;
end;

{--------------------------------------------------------------------------}
procedure CrearArchivo();
var
    nombrefisico:String[20];
    archivoEmpleado:archivo;
    r:registro;
begin
    write('Nombre que va a tener el archivo: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    Rewrite(archivoEmpleado);
    LeerEmpleado(r);
    while (r.apellido <> 'fin') do begin
        write(archivoEmpleado,r);
        LeerEmpleado(r);
    end;
    close(archivoEmpleado);
end;
{--------------------------------------------------------------------------}

procedure ImprimirTodos(var archivoEmpleado:archivo);
var
    regEmp:registro;
begin
    writeln('--TODOS LOS EMPLEADOS--');
    while (not EOF(archivoEmpleado)) do begin
        read(archivoEmpleado,regEmp);
        writeln('Nombre: ',regEmp.nombre);
        writeln('Apellido: ',regEmp.apellido);
        Writeln('Edad: ',regEmp.edad);
        writeln('DNI: ',regEmp.dni);
        writeln('--------------');
    end;
end;

{--------------------------------------------------------------------------}

procedure ImprimirApellido (var archivoEmpleado:archivo);
var
    apellido:String[20];
    regEmp:registro;
begin
    write('Apellido que quiere buscar: ');
    readln(apellido);
    while (not EOF(archivoEmpleado)) do begin
        read(archivoEmpleado,regEmp);
        if (regEmp.apellido = apellido) then begin
            writeln('Nombre: ',regEmp.nombre);
            writeln('Apellido: ',regEmp.apellido);
            Writeln('Edad: ',regEmp.edad);
            writeln('--------------');
        end;
    end;
end;

{--------------------------------------------------------------------------}

procedure ImprimirMayores70(var archivoEmpleado:archivo);
var
    regEmp:registro;
begin
    writeln('--EMPLEADOS MAYORES A 70 ANIOS--');
    while (not EOF(archivoEmpleado)) do begin
        read(archivoEmpleado,regEmp);
        if (regEmp.edad > 70) then begin
            writeln('Nombre: ',regEmp.nombre);
            writeln('Apellido: ',regEmp.apellido);
            Writeln('Edad: ',regEmp.edad);
            writeln('--------------');
        end;
    end;
end;

{--------------------------------------------------------------------------}
procedure ImprimirArchivo();
var
    nombrefisico:String[20];
    archivoEmpleado:archivo;
    opcion:integer;
begin
    write('Nombre del archivo que quiere abrir: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    reset(archivoEmpleado); //abro mi archivo
    writeln('OPCION 1: imprimir todos los empleados.');
    writeln('OPCION 2: imprimir solo los empleados con determinado apellido.');
    writeln('OPCION 3: imprimir los empleados mayores a 70 anios');
    write('Escriba la opcion que usted quiera: ');
    readln(opcion);
    case opcion of
        1:ImprimirTodos(archivoEmpleado);
        2:ImprimirApellido(ArchivoEmpleado);
        3:ImprimirMayores70(archivoEmpleado);
    end;
    close(archivoEmpleado);
end;

{--------------------------------------------------------------------------}

procedure AgregarEmpleado();
var
    cantEmpleados,i:integer;
    r:registro;
    nombrefisico:String[20];
    archivoEmpleado:archivo;
begin
    write('Nombre del archivo que quiere abrir: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    write('Cuantos empleados quiere agregar?: ');
    readln(cantEmpleados);
    reset(ArchivoEmpleado);
    seek(ArchivoEmpleado,FileSize(ArchivoEmpleado));
    for i:=1 to cantEmpleados do begin
        leerEmpleado(r);
        write(ArchivoEmpleado,r);
    end;
    close(archivoEmpleado);
end;

{--------------------------------------------------------------------------}

procedure ModificarEdad();
var
    nombrefisico:String[20];
    archivoEmpleado:archivo;
    terminar:String[2];
    DNIEmp:LongInt;
    r:registro;
    bool:boolean;
begin
    terminar:='no';
    write('Nombre del archivo que quiere abrir: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    reset(ArchivoEmpleado);
    while (terminar <> 'si') do begin
        bool:=false;
        seek(archivoEmpleado,0);
        write('DNI de empleado al que le cambiara la edad: ');
        readln(DNIEmp);
        while (not EOF(archivoEmpleado)) or (not bool) do begin
            read(archivoEmpleado,r);
            if (r.DNI = DNIEmp) then begin
                write('Que edad le pondra a ',r.apellido,': ');
                readln(r.edad);
                seek(ArchivoEmpleado,FilePos(ArchivoEmpleado)-1);
                write(archivoEmpleado,r);
                bool:=true;
            end;
        end;
        write('Desea terminar de cambiar edades? (si o no): ');
        readln(terminar);
    end;
    close(archivoEmpleado);
end;

{--------------------------------------------------------------------------}

procedure ExportarATexto();
var
    carga:Text; //archivo text
    archivoEmpleado:archivo; //archivo binario
    r:registro;
    nombrefisico:String[20];
begin
    write('Nombre del archivo que quiere exportar: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    reset(ArchivoEmpleado); //abro mi archivo binario
    Assign(carga,'todos_empleados.txt');
    rewrite(carga); //creo mi archivo text
    while (not EOF(archivoEmpleado)) do begin
        read(archivoEmpleado,r);
        with r do begin
            writeln(carga,' ',num,' ',edad,' ',DNI,' ',nombre);
            writeln(carga,' ',apellido);
        end;
    end;
    writeln('Archivo exportado correctamente!');
    close(ArchivoEmpleado);
    close(carga);
end;

{--------------------------------------------------------------------------}

procedure ExportarDNI();
var
    carga:Text; //archivo text
    archivoEmpleado:archivo; //archivo binario
    r:registro;
    nombrefisico:String[20];
begin
    write('Nombre del archivo que quiere exportar: ');
    readln(nombrefisico);
    Assign(archivoEmpleado,nombrefisico);
    reset(ArchivoEmpleado); //abro mi archivo binario
    Assign(carga,'faltaDNIEmpleado.txt');
    rewrite(carga); //creo mi archivo text
    while (not EOF(archivoEmpleado)) do begin
        read(archivoEmpleado,r);
        if (r.DNI = 00) then begin
            with r do begin
                writeln(carga,' ',num,' ',edad,' ',DNI,' ',nombre);
                writeln(carga,' ',apellido);
            end;
        end;
    end;
    writeln('Archivo exportado correctamente!');
    close(ArchivoEmpleado);
    close(carga);
end;

{--------------------------------------------------------------------------}

var
    numopcion:integer;
    bool:boolean;
begin
    bool:=false;
    while (not bool) do begin
        writeln('------Que quiere realizar?-------');
        writeln('OPCION 1: Crear un archivo de Empleados.');
        writeln('OPCION 2: Imprimir un archivo ya creado.');
        writeln('OPCION 3: Agregar mas empleados a un archivo ya creado.');
        writeln('OPCION 4: Modificar edad empleados.');
        writeln('OPCION 5: Exportar a archivo de texto.');
        writeln('OPCION 6: Exportar a text los empleados sin DNI(00)');
        writeln('OPCION 7: Salir del programa.');
        writeln('----------------------------------------');
        write('Usted quiere elegir la opcion numero: ');
        readln(numopcion);
        writeln();
        case numopcion of
            1:CrearArchivo;
            2:ImprimirArchivo; 
            3:AgregarEmpleado;
            4:ModificarEdad;
            5:ExportarATexto;
            6:ExportarDNI;
            7:bool:=true;
        end;
    end;
end.