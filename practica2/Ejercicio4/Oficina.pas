{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log}
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
          writeln(texto,' ',cod,' ',fecha);
          writeln(texto,' ',totalSesionesAbiertas);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{-----------------------------------------------------------------------------------------------}

var
    mae:maestro;
    vecArch:vectorArchivoDetalle;
    vecReg:vectorRegistroDetalle;
    i:integer;
    iString:String;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vecArch[i],'detalle'+iString);
        reset(vecArch[i]); //habilito lectura todos los archivos
        Leer(vecArch[i],vecReg[i]);
    end;
    CrearMaestro(vecArch,vecReg);
    exportarATxtMaestro(mae);
end.
    
