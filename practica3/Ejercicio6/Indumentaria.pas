program Indumentaria;
const
    valoralto=9999;
type
    prenda=record
        cod:integer;
        descripcion:string[50];
        stock:integer;
        precio:real;
    end;

    maestro=file of prenda;
    detalle=file of integer;

{--------------------------------------------------------}

procedure Leer2 (var archivoDetalle:detalle; var dato:integer);
begin
    if (not EOF(archivoDetalle)) then
        read(archivoDetalle,dato) //en dato=el dato apuntado en archivoDeta
    else
        dato:=valoralto; //para cortar el while 
end;
{--------------------------------------------------------}

procedure Leer (var mae:maestro; var dato:prenda);
begin
    if (not EOF(mae)) then
        read(mae,dato) //en dato=el dato apuntado en archivoDeta
    else
        dato.cod:=valoralto; //para cortar el while 
end;
{--------------------------------------------------------}

procedure BajaLogica(var mae:maestro;var det:detalle);
var
    regM:prenda;
    regD:integer;
begin
    reset(mae);
    reset(det);
    Leer2(det,regD);
    while (regD <> valoralto) do begin
        seek(mae,0);
        Leer(mae,regM);
        while(regM.cod <> valoralto) do begin
            if(regM.cod=regD) then begin
                regM.stock:=-1;
                seek(mae,filepos(mae)-1);
                write(mae,regM);
            end;
            Leer(mae,regM);
        end;
        Leer2(det,regD);
    end;
    close(mae);
    close(det);
end;

{--------------------------------------------------------}

procedure BajaFisica(var mae,maeNuevo:maestro); //copio los registros no eliminados a un archivo nuevo
var
    regM:prenda;
begin
    reset(mae);
    rewrite(maeNuevo);
    Leer(mae,regM);
    while (regM.cod <> valoralto) do begin
        if (regM.stock <> -1) then
            write(maeNuevo,regM);
        Leer(mae,regM);
    end;
    close(mae);
    close(maeNuevo);
    erase(mae);
    rename(maeNuevo,'maestro');
end;

{--------------------------------------------------------}

procedure ExportarTxt();
var
    texto:Text;
    p:prenda;
    archivo:maestro;
    nom1,nom2:string[20];
begin
    write('Archivo que quiere pasar a txt: ');
    readln(nom1);
    assign(archivo,nom1);
    reset(archivo); 
    write('Nombre que va a tener el txt: ');
    readln(nom2);
    assign(texto,nom2);
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivo)) do begin
        read(archivo,p);
        with p do begin
          writeln(texto,' cod: ',cod,' Stock ',stock);
          writeln(texto,' Precio: ',precio:5:2, ' Descripcion: ',descripcion);
        end;
    end;
    close(texto);
    close(archivo);
end;

{--------------------------------------------------------}
var
    opcion:integer;
    cerrar:boolean;
    mae,maeNuevo:maestro;
    det:detalle;
begin
    cerrar:=true;
    assign(mae,'maestro');
    assign(det,'detalle');
    assign(maeNuevo,'maeNuevo');
    while (cerrar) do begin
        writeln('---MENU----');
        writeln('OPCION 1: Baja logica');
        writeln('OPCION 2: Baja fisica');
        writeln('OPCION 3: Pasar a txt');
        writeln('OPCION 4: Cerrar');
        write('Usted va a elegir la opcion: ');
        readln(opcion);
        case opcion of 
            1:BajaLogica(mae,det);
            2:BajaFisica(mae,maeNuevo);
            3:ExportarTxt();
            4:cerrar:=false;
        end;
    end;
end.