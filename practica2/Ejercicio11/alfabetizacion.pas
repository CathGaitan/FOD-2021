{ A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}
program alfabetizacion;
const
    dimF=2;
    valoralto='ZZZZ';
type
    regMaestro=record
        prov:String[20];
        alfabetizados:integer;
        encuestados:integer;
    end;
    regDetalle=record
        prov:String[20];
        codLocalidad:integer;
        alfabetizados:integer;
        encuestados:integer;
    end;
    maestro=file of regMaestro;
    detalle=file of regDetalle;
    vRegD=array[1..dimF] of regDetalle; //vector registros detalles
    vArcD=array[1..dimF] of detalle;  //vector archivos detalles

{------------------------------------------------------------}

procedure Leer(var archivoDeta:detalle; var datoD:regDetalle);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.prov:=valoralto;
end;
{------------------------------------------------------------}
procedure minimo(var vectorArc:vArcD; var vectorReg:vRegD; var min:regDetalle);
var
    i,minPos:integer;
begin
    min.prov:='ZZZZ';
    for i:=1 to dimF do begin
        if (vectorReg[i].prov < min.prov) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.prov <> valoralto) then
        Leer(vectorArc[minPos],vectorReg[minPos]);
end;
{------------------------------------------------------------}
procedure actualizarMaestro(var vectorArc:vArcD; var vectorReg:vRegD; var mae:maestro);
var
    regM:regMaestro;
    i:integer;
    min:regDetalle;
begin
    minimo(vectorArc,vectorReg,min);//busco la provincia minima entre los archivos detalles
    while (min.prov <> valoralto) do begin //mientras el archivo detalle no termine
        read(mae,regM);
        while(regM.prov <> min.prov) do
            read(mae,regM);
        while(regM.prov = min.prov) do begin
            regM.alfabetizados:=regM.alfabetizados+min.alfabetizados;
            regM.encuestados:=regM.encuestados+min.encuestados;
            minimo(vectorArc,vectorReg,min);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    close(mae);
    for i:=1 to dimF do begin
        close(vectorArc[i]);
    end;
end;
{------------------------------------------------------------}
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
          writeln(texto,' ',prov);
          writeln(texto,' ',encuestados,' ',alfabetizados);
        end;
    end;
    close(texto);
    close(archivoMae);
end;
{------------------------------------------------------------}
var
    i:integer;
    iString:String;
    vectorArc:vArcD; // vector de archivos
    vectorReg:vRegD; //vector de registros
    mae:maestro;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        reset(vectorArc[i]); //habilito lectura todos los archivos
        Leer(vectorArc[i],vectorReg[i]);
    end;
    assign(mae,'maestro');
    reset(mae); //habilito lectura maestro
    actualizarMaestro(vectorArc,vectorReg,mae);
    ExportarATxtMaestro(mae);
end.