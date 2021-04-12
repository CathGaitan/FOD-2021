{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados}
program oficina;
const
    valoralto=9999;
    dimF=2;
type
    regMaestro=record
        cod:integer;
        fecha:longint;
        totalSesionesAbiertas:integer;
    end;
    regDetalle=record
        cod:integer;
        fecha:longint;
        tiempoSesion:integer;
    end;
    maestro=file of regMaestro;
    detalle=file of regDetalle;
    vectorArchivoDetalle=array[1..dimF] of detalle;
    vectorRegistroDetalle=array[1..dimF] of regDetalle;

{-----------------------------------------------------------------------------------------------}
procedure Leer(var archivoDeta:detalle; var datoD:regDetalle);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valoralto;
end;
{-----------------------------------------------------------------------------------------------}

procedure minimo(var vectorArc:vectorArchivoDetalle; var vectorReg:vectorRegistroDetalle; var min:regDetalle);
var
    i,minPos:integer;
begin
    min.cod:=9999;
    min.fecha:=22221231;
    for i:=1 to dimF do begin
        if (vectorReg[i].cod < min.cod) then begin
            if (vectorReg[i].fecha < min.fecha) then begin
                min:=vectorReg[i];
                minPos:=i;
            end;
        end;
    end;
    if (min.cod <> valoralto) then
        leer(vectorArc[minPos],vectorReg[minPos]);
end;

{-----------------------------------------------------------------------------------------------}

procedure CrearMaestro(var vecArch:vectorArchivoDetalle;var vecReg:vectorRegistroDetalle);
var
    mae:maestro;
    min:regDetalle;
    regM:regMaestro;
    i,totalhoras:integer;
begin
    assign(mae,'maestro');
    rewrite(mae); //creo mi maestro
    minimo(vecArch,vecReg,min); //busco el de codminimo y fecha minima
    while(min.cod <> valoralto) do begin
        regM.cod:=min.cod;
        regM.fecha:=min.fecha;
        totalhoras:=0;
        while ((min.cod=regM.cod) and (min.fecha=regM.fecha)) do begin
            totalhoras:=totalhoras+min.tiempoSesion;        
            minimo(vecArch,vecReg,min);
        end;
        regM.totalSesionesAbiertas:=totalhoras;
        write(mae,regM);
    end;
    close(mae);
    for i:=1 to dimF do
      close(vecArch[i]);
end;

{-----------------------------------------------------------------------------------------------}
procedure ExportarATxtMaestro(var archivoMae:maestro);
var
    texto:Text;
    r:regMaestro;
begin
    assign(archivoMae,'maestro');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTMAESTRO');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' cod: ',cod,' fecha: ',fecha);
          writeln(texto,' total sesiones: ',totalSesionesAbiertas);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{-----------------------------------------------------------------------------------------------}
procedure Leer2(var archivo:maestro; var dato:reGmaestro);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.cod:=valoralto;
end;
{-----------------------------------------------------------------------------------------------}

procedure EliminarReg();
var
    mae:maestro;
    regM,ultReg:regMaestro;
    codBorrar:integer;
begin
    assign(mae,'maestro');
    reset(mae); //abro mi maestro viejo
    write('Codigo del usuario que quiere eliminar: ');
    readln(codBorrar);
    seek(mae,filesize(mae));
    write(mae,ultReg); //ultReg=ultimo registro de mi
    seek(mae,0); //posiciono mi archivo al principio
    leer2(mae,regM);
    while ((regM.cod <> codBorrar) and (regM.cod <> valoralto)) do
        leer2(mae,regM);
    if (regM.cod <> valoralto) then begin
        seek(mae,filepos(mae)-1);
        write(mae,ultReg); //escribo en el reg a borrar el reg que estaba ultimo en el archivo
        seek(mae,filesize(mae)); //posiciono al final del archivo
        truncate(mae); //trunco el archivo para evitar reg duplicados
    end
    else
        writeln('No se encontro ese codigo');
    close(mae);
end;

{-----------------------------------------------------------------------------------------------}
var
    mae:maestro;
    vecArch:vectorArchivoDetalle;
    vecReg:vectorRegistroDetalle;
    i,opcion:integer;
    iString:String;
    cerrar:boolean;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vecArch[i],'detalle'+iString);
        reset(vecArch[i]); //habilito lectura todos los archivos
        Leer(vecArch[i],vecReg[i]);
    end;
    cerrar:=true;
    while(cerrar) do begin
        writeln('----MENU-----');
        writeln('OPCION 1: Crear un maestro');
        writeln('OPCION 2: Exportar a un txt el maestro');
        writeln('OPCION 3: Eliminar un registro del maestro');
        writeln('OPCION 4: Cerrar programa');
        write('Usted va a elegir la opcion: ');
        readln(opcion);
        case opcion of
            1:CrearMaestro(vecArch,vecReg);
            2:exportarATxtMaestro(mae);
            3:EliminarReg;
            4:cerrar:=false;
        end;
    end;
end.
    
