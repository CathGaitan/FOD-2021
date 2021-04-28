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

procedure BuscarUltReg(var archivo:archivoAves; var ultReg:ave; var ultpos:integer);
begin
    seek(archivo,ultpos); //1era vez=final del archivo(este borrado o no) - demas veces=nos vamos moviendo para atras 
     read(archivo,ultReg);
     while(ultReg.cod = -1) do begin //busco el ultimo registro NO borrado
         seek(archivo,ultpos-1); 
         ultpos:=filepos(archivo); //ultpos=ubicacion del ultimo rengistro borrado. Lo uso para reemplazar
         read(archivo,ultReg);
     end;
 end;
{--------------------------------------------------------------}
//MAS EFICIENTE - HAGO UN SOLO TRUNCATE
procedure BajaFisica();
var
    reg,ultReg:ave;
    pos,ultpos:integer;
    archivo:archivoAves;
begin
    assign(archivo,'archivoAves');
    reset(archivo);
    Leer(archivo,reg); //leo un reg
     ultpos:=filesize(archivo); //ultPos=tamanio de mi archivo
     while ((reg.cod<>valoralto) and (filepos(archivo)<=ultpos)) do begin //mientras noEOF
         pos:=filepos(archivo); //pos=donde estoy parada
         if(reg.cod = -1) then begin
             ultpos:=ultpos-1; //decremento mi pos
             BuscarUltReg(archivo,ultReg,ultpos); //busco el ultimo registro NO borrado
             seek(archivo,pos-1);
             write(archivo,ultReg);
         end;
        Leer(archivo,reg);
    end;
    seek(archivo,ultpos+1);
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