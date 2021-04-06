{Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado
“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez}
program Facultadinfo;
const
    valorbajo=-1;
type
    alumno=record
        cod:integer;
        nombre:string[20];
        apellido:string[20];
        cursadas:integer;
        finales:integer;
    end;

    alumnodet=record
        cod:integer;
        aprobo:integer; //0=aprobo cursada
    end;                //1=aprobo final

    detalle = file of alumnodet;
    maestro = file of alumno;

{---------------------------------------------------------------}

procedure CrearBinarioMaestro();
var
    nombrefisico:String[20];
    archivoMae:maestro;
    texto:Text;
    r:alumno;
begin
    assign(texto,'alumnos');
    reset(texto); //abro mi txt
    write('Nombre del archivo nuevo: ');
    readln(nombrefisico);
    assign(archivoMae,nombrefisico);
    rewrite(archivoMae); //creo mi archivo binario
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,cursadas,finales,nombre);
            readln(texto,apellido); //guardo en r los datos que estaban en el txt
        end;
        write(archivoMae,r);
    end;
    writeln('Archivo cargado correctamente');
    close(archivoMae);
    close(texto);
end;

{---------------------------------------------------------------}

procedure CrearBinarioDetalle();
var
    nombrefisico:String[20];
    archivoDet:detalle;
    texto:Text;
    r:alumnodet;
begin
    assign(texto,'detalle');
    reset(texto); //abro mi txt
    write('Nombre del archivo nuevo: ');
    readln(nombrefisico);
    assign(archivoDet,nombrefisico);
    rewrite(archivoDet); //creo mi archivo binario
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,aprobo); //guardo en r los datos que estaban en el txt
        end;
        write(archivoDet,r);
    end;
    writeln('Archivo cargado correctamente');
    close(archivoDet);
    close(texto);
end;

{---------------------------------------------------------------}

procedure ExportarATxtMaestro();
var
    nombrefisico:String[20];
    archivoMae:maestro;
    r:alumno;
    texto:Text;
begin
    write('Nombre del archivo que quiere pasar a TXT: ');
    readln(nombrefisico);
    assign(archivoMae,nombrefisico);
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'reporteAlumnos');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',cod,' ',cursadas,' ',finales,' ',nombre);
          writeln(texto,' ',apellido);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{---------------------------------------------------------------}

procedure ExportarATxtDetalle();
var
    nombrefisico:String[20];
    archivoDet:detalle;
    r:alumnodet;
    texto:Text;
begin
    write('Nombre del archivo que quiere pasar a TXT: ');
    readln(nombrefisico);
    assign(archivoDet,nombrefisico);
    reset(archivoDet); //abro mi archivo binario
    assign(texto,'reporteDetalle');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoDet)) do begin
        read(archivoDet,r);
        with r do
          writeln(texto,' ',cod,' ',aprobo);
    end;
    close(texto);
    close(archivoDet);
end;


{---------------------------------------------------------------}

procedure Leer (var archivoDeta:detalle; var datoD:alumnodet);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valorbajo;
end;

{---------------------------------------------------------------}

procedure ActualizarMaestro();
var
    regM:alumno;
    regD:alumnodet;
    mae:maestro;
    det:detalle;
    auxcod:integer;
    nomMaestro,nomdetalle:string[20];
    totalCursada,totalFinal:integer;
begin
    write('Nombre del archivo maestro: ');
    readln(nomMaestro);
    assign(mae,nomMaestro);
    write('Nombre del detalle: ');
    readln(nomdetalle);
    assign(det,nomdetalle);
    reset(mae); // los abro para
    reset(det); // hacer lectura
    read(mae,regM);
    leer(det,regD);
    while(regD.cod <> valorbajo) do begin
        auxcod:=regD.cod;
        totalCursada:=0;
        totalFinal:=0;
        while(auxcod = regD.cod) do begin
            if (regD.aprobo = 0) then begin
                totalCursada:=totalCursada+1;
            end
            else 
                totalFinal:=totalFinal+1;
            leer(det,regD);
        end;
        while (regM.cod <> auxcod) do
            read(mae,regM);
        regM.cursadas:=regM.cursadas+totalCursada;
        regM.finales:=regM.finales+totalFinal;
        seek(mae,filePos(mae)-1);
        write(mae,regM);
        if (not EOF(mae)) then
            read(mae,regM);
    end;
    close(mae);
    close(det);
end;

{---------------------------------------------------------------}

procedure TxtMasCuatroCursadas();
var
    nombrefisico:String[20];
    archivoMae:maestro;
    r:alumno;
    texto:Text;
begin
    write('Nombre del archivo que quiere pasar a TXT: ');
    readln(nombrefisico);
    assign(archivoMae,nombrefisico);
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'MasDeCuatroCursadasAprobadas');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        if (r.cursadas > 4) then begin
            with r do
                writeln(texto,' ',cod,' ',nombre,' ',apellido,' ',cursadas,' ',finales);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{---------------------------------------------------------------}
var
    opcion:integer;
    bool:boolean;
begin
    bool:=false;
    while(not bool) do begin
        writeln('------MENU-------');
        writeln('OPCION 1: Crear Maestro a partir de txt');
        writeln('OPCION 2: Crear Detalle a partir de txt');
        writeln('OPCION 3: Pasar el contenido del Maestro a un txt');
        writeln('OPCION 4: Pasar el contenido del Detalle a un txt');
        writeln('OPCION 5: Actualizar el Maestro');
        writeln('OPCION 6: Guardar en un txt los alumnos que tengan mas de cuatro cursadas aprobadas');
        writeln('OPCION 7: Cerrar el programa');
        write('Opcion a elegir: ');
        readln(opcion);
        case opcion of
            1:CrearBinarioMaestro();
            2:CrearBinarioDetalle();
            3:ExportarATxtMaestro();
            4:ExportarATxtDetalle();
            5:ActualizarMaestro();
            6:TxtMasCuatroCursadas();
            7:bool:=true;
        end;
    end;
end.
