{ El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada
venta se registra: código de producto y cantidad de unidades vendidas. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “productos.txt”.
b. Listar el contenido del archivo maestro en un archivo de texto llamado “reporte.txt”,
listando de a un producto por línea.
c. Crear un archivo detalle de ventas a partir de en un archivo de texto llamado
“ventas.txt”.
d. Listar en pantalla el contenido del archivo detalle de ventas.
e. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
f. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido}
program Negocio;
const
    valoralto=9999;
type
    producto=record  ///REGISTRO MAESTRO
        cod:integer;
        nombre:String[20];
        precio:real;
        stockAct:integer;
        stockMin:integer;
    end;
    
    venta=record  //REGISTRO DETALLE
        cod:integer;
        cantVendida:integer;
    end;

    maestro=file of producto;
    detalle=file of venta;

{--------------------------------------------------------------}

procedure CrearBinarioMaestro();
var
    nombrefisico:String[20];
    archivoMae:maestro;
    texto:Text;
    r:producto;
begin
    assign(texto,'productos');
    reset(texto); //abro mi txt
    write('Nombre que va a tener el maestro binario: ');
    readln(nombrefisico);
    assign(archivoMae,nombrefisico);
    rewrite(archivoMae); //creo mi archivo binario
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,nombre); //guardo en r los datos que estaban en el txt
            readln(texto,stockAct,stockMin,precio); //separo para prolijidad
        end;
        write(archivoMae,r);
    end;
    writeln('Archivo cargado correctamente');
    close(archivoMae);
    close(texto);
end;

{--------------------------------------------------------------}
procedure CrearBinarioDetalle();
var
    nombrefisico:String[20];
    archivoDet:detalle;
    texto:Text;
    r:venta;
begin
    assign(texto,'ventas');
    reset(texto); //abro mi txt
    write('Nombre que va a tener el binario detalle: ');
    readln(nombrefisico);
    assign(archivoDet,nombrefisico);
    rewrite(archivoDet); //creo mi archivo binario
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,cantVendida); //guardo en r los datos que estaban en el txt
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
    r:producto;
    texto:Text;
begin
    write('Nombre del archivo que quiere pasar a TXT: ');
    readln(nombrefisico);
    assign(archivoMae,nombrefisico);
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'reporte');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',cod,' ',nombre);
          writeln(texto,' ',stockAct,' ',stockMin,' ',precio:5:2);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

{---------------------------------------------------------------}

procedure MostrarEnPantallaDetalle();
var
    nombrefisico:String[20];
    archivoDet:detalle;
    r:venta;
begin
    write('Nombre del archivo que quiere mostrar en pantalla: ');
    readln(nombrefisico);
    assign(archivoDet,nombrefisico);
    reset(archivoDet); //abro mi archivo binario
    while(not EOF(archivoDet)) do begin
        read(archivoDet,r);
        with r do begin
            writeln('----VENTA-----');
            writeln('Codigo de producto: ',cod);
            writeln('Cantidad vendidad: ',cantVendida);
        end;
    end;
    close(archivoDet);
end;

{--------------------------------------------------------------}
procedure Leer (var archivoDeta:detalle; var datoD:venta);
begin
    if (not EOF(archivoDeta)) then
        read(archivoDeta,datoD) //en datoD=el dato apuntado en archivoDeta
    else
        datoD.cod:=valoralto; //para cortar el while 
end;
{--------------------------------------------------------------}

procedure ActualizarMaestro();
var
    nomMaestro,nomDetalle:String[20];
    det:detalle;
    mae:maestro;
    regM:producto;
    regD:venta;
    auxcod,totalventas:integer;
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
    while (regD.cod <> valoralto) do begin
        auxcod:=regD.cod;
        totalventas:=0;
        while (auxcod = regD.cod) do begin //mientras sea el mismo producto
            totalventas:=totalventas+regD.cantVendida;
            leer(det,regD); //busco otra venta
        end;
        while (regM.cod <> auxcod) do
            read(mae,regM); //busco en el maestro un codigo igual al del detalle
        regM.stockAct:=regM.stockAct-totalventas;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
        if (not EOF(mae)) then
            read(mae,regM);
    end;
    close(mae);
    close(det);
end;

{--------------------------------------------------------------}

procedure ExportarStockMin();
var
    texto:Text;
    r:producto;
    archivoMae:maestro;
    nombre:string[20];
begin
    write('Nombre del archivo binario Maestro: ');
    readln(nombre);
    assign(archivoMae,nombre);
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'TXTStockDispMenorAlMinimo');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        if (r.stockAct < r.stockMin) then begin
            with r do begin
             writeln(texto,' ',cod,' ',nombre);
            writeln(texto,' ',stockAct,' ',stockMin,' ',precio:5:2);
            end;
        end;
    end;
    close(texto);
    close(archivoMae);
end;


{--------------------------------------------------------------}
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
        writeln('OPCION 4: Mostrar en pantalla el detalle');
        writeln('OPCION 5: Actulizar maestro');
        writeln('OPCION 6: Exportar a TXT los productos que stockDisponible < stockMinimo');
        writeln('OPCION 7: Cerrar el programa');
        write('Opcion a elegir: ');
        readln(opcion);
        case opcion of
            1:CrearBinarioMaestro();
            2:CrearBinarioDetalle();
            3:ExportarATxtMaestro();
            4:MostrarEnPantallaDetalle();
            5:ActualizarMaestro();
            6:ExportarStockMin();
            7:bool:=true;
        end;
    end;
end.