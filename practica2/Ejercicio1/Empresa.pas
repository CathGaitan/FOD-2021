program Empresa;
const
    valoralto=9999;
type
    empleado=record
        cod:integer;
        nombre:string[20];
        monto:real;
    end;

    ArchEmpleado=file of empleado;
{--------------------------------------------------------------------}

procedure leer(var archivo:ArchEmpleado;var dato:empleado);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.cod:=valoralto;
end;

{--------------------------------------------------------------------}

procedure ExportarATxtMaestro(var archivoMae:ArchEmpleado);
var
    texto:Text;
    r:empleado;
begin
    assign(archivoMae,'archivoMaestro');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTMAESTRO');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',cod,' ',nombre);
          writeln(texto,' ',monto:5:2);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{--------------------------------------------------------------------}
var
    regD,RegAux:empleado;
    det,mae:ArchEmpleado;
    auxcod:integer;
    total:real;
begin
    assign(mae,'archivoMaestro');
    rewrite(mae); //creo mi nuevo archivo
    assign(det,'detalle');
    reset(det); //abro mi archivo que ya tiene la info
    leer(det,regD); //obtengo mi primer empleado
    while (regD.cod <> valoralto) do begin //mientras no haya terminado mi det
        RegAux:=regD; //guardo mi codigo
        total:=0; //inicializo total de ese empleado
        while (regD.cod = RegAux.cod) do begin //mientras no cambie el empleado
            total:=total+regD.monto;  //acumulo sus ventas
            leer(det,regD); //busco al sig
        end;
        RegAux.monto:=total;
        write(mae,RegAux); //escribo en mi maestro, el empleado con el monto total
    end;
    close(mae);
    close(det);
    ExportarATxtMaestro(mae);
end.
    