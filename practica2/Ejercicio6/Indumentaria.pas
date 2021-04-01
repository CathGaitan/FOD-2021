program Indumentaria;
const
    dimF=3;
    valoralto=9999;
type
    articulo=record
        cod:integer;
        nombre:String[20];
        stockDisp:integer;
        stockMin:integer;
        precio:real; //borro campos que estan al cuete
    end;

    regDetalle=record
        cod:integer;
        cantvendida:integer;
    end;

    maestro=file of articulo;
    detalle=file of regDetalle;
    vectorArchivoDetalle=array[1..dimF] of detalle;
    vectorRegistroDetalle=array[1..dimf] of regDetalle;

{-------------------------------------------------------------------}
procedure Leer(var archivoDeta:detalle; var datoD:regDetalle);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valoralto;
end;

{-------------------------------------------------------------------}

procedure minimo(var vectorArc:vectorArchivoDetalle; var vectorReg:vectorRegistroDetalle; var min:regDetalle);
var
    i,minPos:integer;
begin
    min.cod:=9999;
    for i:=1 to dimF do begin
        if (vectorReg[i].cod < min.cod) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.cod <> valoralto) then
        Leer(vectorArc[minPos],vectorReg[minPos]);
end;

{-------------------------------------------------------------------}

procedure actualizarMaestro(var vectorArc:vectorArchivoDetalle; var vectorReg:vectorRegistroDetalle);
var
    regM:articulo;
    i:integer;
    min:regDetalle;
    mae:maestro;
begin
    assign(mae,'maestro');
    reset(mae);
    minimo(vectorArc,vectorReg,min);//busco el codigo minimo entre los archivos detalles
    while (min.cod <> valoralto) do begin //mientras el archivo detalle no termine
        read(mae,regM);
        while(regM.cod <> min.cod) do
            read(mae,regM);
        while(regM.cod = min.cod) do begin
            regM.stockDisp:=regM.stockDisp-min.cantvendida;
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

{-------------------------------------------------------------------}

procedure TxtStockMenorAlMinimo();
var
    texto:Text;
    r:articulo;
    nombre:String[20];
    archivoMae:maestro;
begin
    writeln('Nombre del archivo maestro: ');
    readln(nombre);
    assign(archivoMae,nombre);
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTMAESTRO');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',cod,' ',nombre);
          writeln(texto,' ',stockDisp,' ',stockMin,' ',precio:5:2);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{-------------------------------------------------------------------}
var
    i:integer;
    iString:string;
    vectorArc:vectorArchivoDetalle;
    vectorReg:vectorRegistroDetalle;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        reset(vectorArc[i]);
        Leer(vectorArc[i],vectorReg[i]);
    end;
    actualizarMaestro(vectorArc,vectorReg);
    TxtStockMenorAlMinimo();
end.


