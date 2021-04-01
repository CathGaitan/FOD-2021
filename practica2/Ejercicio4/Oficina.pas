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
    
