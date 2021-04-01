program congelados;
const
    dimF=3;
    valoralto=9999;
type
    producto=record
        cod:integer;
        nombre:String[20];
        stockDisp:integer;
        stockMin:integer;
        precio:real;
    end;

    productoDet=record
        cod:integer;
        cant_vendida:integer;
    end;

    maestro = file of producto;
    detalle=file of productoDet;
    vecDetalle=array[1..dimF] of detalle; //vector de archivos detalle
    vecRegDetalle=array[1..dimF] of productoDet; //vector de registros detalle
    
{------------------------------------------------------------}

procedure Leer(var archivoDeta:detalle; var datoD:productoDet);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valoralto;
end;

{------------------------------------------------------------}

procedure minimo(var vectorArc:vecDetalle; var vectorReg:vecRegDetalle; var min:productoDet);
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

{------------------------------------------------------------}

procedure actualizarMaestro(var vectorArc:vecDetalle; var vectorReg:vecRegDetalle; var mae:maestro);
var
    regM:producto;
    i:integer;
    min:productoDet;
begin
    minimo(vectorArc,vectorReg,min);//busco el codigo minimo entre los archivos detalles
    while (min.cod <> valoralto) do begin //mientras el archivo detalle no termine
        read(mae,regM);
        while(regM.cod <> min.cod) do
            read(mae,regM);
        while(regM.cod = min.cod) do begin
            regM.stockDisp:=regM.stockDisp-min.cant_vendida;
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
    r:producto;
begin
    assign(archivoMae,'binarioMaestro');
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

{------------------------------------------------------------}

procedure ExportarStockMin(var archivoMae:maestro);
var
    texto:Text;
    r:producto;
begin
    assign(archivoMae,'binarioMaestro');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTStockDispMenorAlMinimo');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        if (r.stockDisp < r.stockMin) then begin
            with r do begin
             writeln(texto,' ',cod,' ',nombre);
            writeln(texto,' ',stockDisp,' ',stockMin,' ',precio:5:2);
            end;
        end;
    end;
    close(texto);
    close(archivoMae);
end;


{------------------------------------------------------------}

var
    i:integer;
    iString:String;
    vectorArc:vecDetalle; // vector de archivos
    vectorReg:vecRegDetalle; //vector de registros
    mae:maestro;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        reset(vectorArc[i]); //habilito lectura todos los archivos
        Leer(vectorArc[i],vectorReg[i]);
    end;
    assign(mae,'binarioMaestro');
    reset(mae); //habilito lectura maestro
    actualizarMaestro(vectorArc,vectorReg,mae);
    ExportarATxtMaestro(mae);
    ExportarStockMin(mae);
end.