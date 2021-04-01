program EjercicioCelulares;
type
    registro = record
        cod:integer;
        nombre:String[20];
        descrip:String[20];
        marca:String[20];
        precio:real;
        stockmin:integer;
        stockdisp:integer;
    end;

    archivo = file of registro;

{-------------------------------------------------------------------}

procedure CrearBinarioDesdeTxt();
var
    nombretxt,nombrefisico:String[20];
    archivoCelulares:archivo;
    texto:Text;
    r:registro;
begin
    write('Nombre del archivo txt: ');
    readln(nombretxt);
    assign(texto,nombretxt);
    reset(texto); //abro mi txt
    write('Nombre del archivo nuevo: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    rewrite(archivoCelulares); //creo mi archivo binario
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,stockdisp,stockmin,precio,nombre);
            readln(texto,descrip);
            readln(texto,marca); //guardo en r los datos que estaban en el txt
        end;
        write(archivoCelulares,r);
    end;
    writeln('Archivo cargado correctamente');
    close(archivoCelulares);
    close(texto);
end;

{-------------------------------------------------------------------}

procedure ImprimirStock();
var
    archivoCelulares:archivo;
    nombrefisico:String[20];
    r:registro;
begin
    write('Nombre del archivo que quiere imprimir con stock menor: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    reset(archivoCelulares);
    while (not EOF(archivoCelulares)) do begin
        read(archivoCelulares,r);
        if (r.stockdisp < r.stockmin) then begin
            writeln('Marca: ',r.marca);
            writeln('Nombre: ',r.nombre);
            writeln('Stock minimo: ',r.stockmin);
            writeln('Stock disponible: ',r.stockmin);
            writeln('--------------------------------');
        end;
    end;
    close(archivoCelulares);
end;

{-------------------------------------------------------------------}

procedure ImprimirDescripcion();
var
    archivoCelulares:archivo;
    nombrefisico,cadena:String[20];
    r:registro;
begin
    write('Nombre del archivo que quiere imprimir con descripcion determinada: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    reset(archivoCelulares);
    write('Cadena de caracteres a buscar: ');
    readln(cadena);
    while (not EOF(archivoCelulares)) do begin
        read(archivoCelulares,r);
        if Pos(cadena,r.descrip)<>0 then begin
            writeln('Marca: ',r.marca);
            writeln('Nombre: ',r.nombre);
            writeln('Stock minimo: ',r.stockmin);
            writeln('Stock disponible: ',r.stockdisp);
            writeln('--------------------------------');    
        end;
    end;
    close(archivoCelulares);
end;

{-------------------------------------------------------------------}

procedure ExportarATxt();
var
    nombrefisico:String[20];
    archivoCelulares:archivo;
    r:registro;
    texto:Text;
begin
    write('Nombre del archivo que quiere pasar a TXT: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    reset(archivoCelulares); //abro mi archivo binario
    assign(texto,'celular.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoCelulares)) do begin
        read(archivoCelulares,r);
        with r do
          writeln(texto,' ',cod,' ',nombre,' ',descrip,' ',marca,' ',precio:5:2,' ',stockmin,' ',stockdisp);
    end;
    close(texto);
    close(archivoCelulares);
end;

{-------------------------------------------------------------------}
procedure LeerCelular(var r:registro);
begin
    writeln('----CELULAR----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Descripcion: ');
        readln(r.descrip);
        write('Marca: ');
        readln(r.marca);
        write('Precio: ');
        readln(r.precio);
        write('Stock minimo: ');
        readln(r.stockmin);
        write('Stock disponible: ');
        readln(r.stockdisp);
    end;
end;

{-------------------------------------------------------------------}

procedure AgregarCelulares();
var
    cantCelulares,i:integer;
    r:registro;
    nombrefisico:String[20];
    archivoCelulares:archivo;
begin
    write('Nombre del archivo que quiere abrir: ');
    readln(nombrefisico);
    Assign(archivoCelulares,nombrefisico);
    write('Cuantos celulares quiere agregar?: ');
    readln(cantCelulares);
    reset(ArchivoCelulares);
    seek(ArchivoCelulares,FileSize(ArchivoCelulares));
    for i:=1 to cantCelulares do begin
        leerCelular(r);
        write(ArchivoCelulares,r);
    end;
    close(archivoCelulares);
end;

{-------------------------------------------------------------------}

procedure ModificarStock();
var
    archivoCelulares:archivo;
    r:registro;
    nombrefisico:String[20];
    bool:boolean;
    codcelular:integer;
begin
    bool:=false;
    write('Nombre del archivo que quiere abrir: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    reset(archivoCelulares); //abro mi archivo binario
    write('Codigo de celular al que le quiera cambiar el stock: ');
    readln(codcelular);
    while (not EOF(archivoCelulares) or (not bool)) do begin
        read(archivoCelulares,r);
        if (codcelular = r.cod) then begin
            write('Nueva cantidad de stock: ');
            readln(r.stockdisp);
            seek(ArchivoCelulares,FilePos(ArchivoCelulares)-1);
            write(archivoCelulares,r);
            bool:=true;
        end;
    end;
    if (not bool) then 
        writeln('Ese codigo de celular no corresponde a ningun celular');
    close(archivoCelulares);
end;

{-------------------------------------------------------------------}

procedure TextStockCero();
var
    nombrefisico:String[20];
    texto:Text;
    archivoCelulares:archivo;
    r:registro;
begin
    write('Nombre del archivo para pasar a TXT los productos con stock 0: ');
    readln(nombrefisico);
    assign(archivoCelulares,nombrefisico);
    reset(archivoCelulares); //abro mi archivo binario
    assign(texto,'SinStock.txt');
    rewrite(texto); //creo mi archivo de texto    
    while (not EOF(archivoCelulares)) do begin
        read(archivoCelulares,r);
        if (r.stockdisp = 0) then begin
            with r do
                writeln(texto,' ',cod,' ',nombre,' ',descrip,' ',marca,' ',precio:5:2,' ',stockmin,' ',stockdisp);
        end;
    end;
    close(archivoCelulares);
    close(texto);
end;

{-------------------------------------------------------------------}

var
    opcion:integer;
    bool:boolean;
begin
    bool:=false;
    while(not bool) do begin
        writeln('------MENU-------');
        writeln('OPCION 1: Crear archivo binario desde un TXT');
        writeln('OPCION 2: Imprimir celulares con stock < stock minimo');
        writeln('OPCION 3: Imprimir celulares con descripcion determinada');
        writeln('OPCION 4: Exportar archivo a TXT.');
        writeln('OPCION 5: Agregar celulares a un archivo ya creado');
        writeln('OPCION 6: Modificar stock de un archivo ya creado');
        writeln('OPCION 7: Exportar a txt los celulares con stock=0');
        writeln('OPCION 8: Cerrar el programa');
        write('Opcion a elegir: ');
        readln(opcion);
        case opcion of
            1:CrearBinarioDesdeTxt();
            2:ImprimirStock();
            3:ImprimirDescripcion();
            4:ExportarATxt();
            5:AgregarCelulares();
            6:ModificarStock();
            7:TextStockCero();
            8:bool:=true;
        end;
    end;
end.