program Aves;
const
    valoralto=9999;
type
    ave=record
        cod:integer;
        nombre:string[50];
        zonaGeografica:string[50];
    end;
    archivoAves=file of ave;

{--------------------------------------------------------------}
procedure Leer (var archivo:archivoAves; var dato:ave);
begin
    if (not EOF(archivo)) then
        read(archivo,dato) //en dato=el dato apuntado en archivoDeta
    else
        dato.cod:=valoralto; //para cortar el while 
end;
{--------------------------------------------------------------}

procedure BajaLogica();
var
    archivo:archivoAves;
    reg:ave;
    codAve:integer;
begin
    assign(archivo,'archivoAves');
    reset(archivo);
    writeln('ESCRIBA 500 PARA FINALZAR LAS BAJAS');
    write('Codigo de ave que quiera borrar: ');
    readln(codAve);
    while(codAve <> 500) do begin
        seek(archivo,0);
        Leer(archivo,reg);
        while(reg.cod <> valoralto) do begin
            if (reg.cod = codAve) then begin
                reg.cod:=-1;
                seek(archivo,filepos(archivo)-1);
                write(archivo,reg);
            end;
            Leer(archivo,reg);
        end;
        write('Codigo de ave que quiere borrar: ');
        readln(codAve);
    end;
    close(archivo);
end;

{--------------------------------------------------------------}

procedure BajaFisica();
var
    archivo:archivoAves;
    reg,regAux:ave;
    cantBorrados,pos:integer;
begin
    cantBorrados:=0;
    assign(archivo,'archivoAves');
    reset(archivo);
    Leer(archivo,reg);
    while(reg.cod <> valoralto) do begin
        if (reg.cod = -1) then begin
            cantBorrados:=cantBorrados+1;
            pos:=filepos(archivo)-1; //guardo pos de mi archivo con cod -1
            seek(archivo,filesize(archivo)); //voy a final del archivo
            read(archivo,regAux); // regAux= ultimo regAux
            seek(archivo,pos);//en la pos de mi archivo con cod -1 
            write(archivo,regAux);//pongo el ult reg
        end;
        Leer(archivo,reg);
    end;
    seek(archivo,filesize(archivo)-cantBorrados);
    truncate(archivo);
    close(archivo);
end;

{--------------------------------------------------------------}

procedure ExportarATexto();
var
    carga:Text; //archivo text
    archivo:archivoAves; //archivo binario
    a:ave;
    nombre:String[20];
begin
    assign(archivo,'archivoAves');
    reset(archivo); //abro mi archivo binario
    write('Nombre que va a tener el txt: ');
    readln(nombre);
    Assign(carga,nombre);
    rewrite(carga); //creo mi archivo text
    while (not EOF(archivo)) do begin
        read(archivo,a);
        with a do begin
            writeln(carga,' Codigo: ',cod,' Nombre: ',nombre);
            writeln(carga,' Zona: ',zonaGeografica);
        end;
    end;
    close(archivo);
    close(carga);
end;

{--------------------------------------------------------------}
var
    opcion:integer;
    corte:boolean;
begin 
    corte:=true;
    while(corte) do begin
        writeln('---MENU----');
        writeln('OPCION 1: Baja logica');
        writeln('OPCION 2: Baja fisica');
        writeln('OPCION 3: Pasar a txt');
        writeln('OPCION 4: Cerrar');
        write('Usted va a elegir la opcion: ');
        readln(opcion);
        case opcion of
            1:BajaLogica();
            2:BajaFisica();
            3:ExportarATexto();
            4:corte:=false;
        end;
    end;
end.