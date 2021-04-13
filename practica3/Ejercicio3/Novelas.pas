program Novelas;
const
    valoralto=9999;
type
    novela=record
        cod:integer;
        genero:string[20];
        nombre:string[20];
    end;
    archivoNov= file of novela;

{----------------------------------------------------------}

procedure Leer (var archivo:archivoNov; dato:novela);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato.cod:=valoralto;
end;
{----------------------------------------------------------}
procedure LeerNovela(var n:novela);
begin
    writeln('---NOVELA----');
    write('Codigo: ');
    readln(n.cod);
    if (n.cod <> valoralto) then begin
        write('Nombre: ');
        readln(n.nombre);
        write('Genero: ');
        readln(n.genero);
    end;
end;
{----------------------------------------------------------}

procedure CrearArchivo();
var
    archivo:archivoNov;
    n:novela;
    nombre:string[20];
begin
    write('Nombre que va a tener su archivo: ');
    readln(nombre);
    assign(archivo,nombre);
    Rewrite(archivo);
    n.cod:=0; //lista invertida
    write(archivo,n);
    LeerNovela(n);
    while (n.cod <> 9999) do begin
        write(archivo,n);
        LeerNovela(n);
    end;
    close(archivo);
end;
{----------------------------------------------------------}
procedure DarDeAlta(var archivo:archivoNov);
var
    reg,regAux,n:novela;
begin
    seek(archivo,0);
    leer(archivo,reg);// reg=registro Cabecera 
    if(reg.cod = 0) then begin
        writeln('No hay espacio para una almacenar una nueva novela');
    end
    else begin
        LeerNovela(n); //n=NUEVA NOVELA
        //Ej: si en reg Cabecera hay -5, leo la pos5 y lo copio en la pos0
        seek(archivo,(reg.cod*-1));
        read(archivo,regAux); //regAux=para copiarlo en posicion 0
        seek(archivo,0);
        write(archivo,regAux); //copio el archivo borrado en 0
        //Ej: Grabo el nuevo registro en la pos 5
        seek(archivo,(reg.cod*-1));
        write(archivo,n);
    end;
end;
{----------------------------------------------------------}

procedure ModificarDatos(var archivo:archivoNov);
procedure CambiarNombre(var reg:novela);
begin
    write('Nombre nuevo: ');
    readln(reg.nombre);
end;
procedure CambiarGenero(var reg:novela);
begin
    write('Genero nuevo: ');
    readln(reg.genero);
end;
var
    reg:novela;
    corte:boolean;
    codnov,opcion:integer;
begin
    seek(archivo,1);
    corte:=true;
    write('Codigo de novela al que quiera modificarle los datos: ');
    readln(codnov);
    leer(archivo,reg);
    while ((reg.cod<>valoralto) and (corte)) do begin
        if (reg.cod = codnov) then begin
            writeln('Que le va a modificar a la novela de codigo ',codnov,'?');
            writeln('1. El genero');
            writeln('2. El nombre');
            write('elige el: ');
            readln(opcion);
            case opcion of
                1:CambiarGenero(reg);
                2:CambiarNombre(reg);
            end;
            seek(archivo,filepos(archivo)-1);
            write(archivo,reg);
            corte:=false;
        end;
        leer(archivo,reg);
    end;
end; 
{----------------------------------------------------------}

procedure EliminarUnaNovela(var archivo:archivoNov);
var
    reg,regAux:novela;
    codborrar:integer;
begin
    write('Codigo de la novela que quiere eliminar: ');
    readln(codborrar);
    //---------------
    seek(archivo,0);  
    Leer(archivo,regAux);//regAux=registro Cabecera
    seek(archivo,0);
    reg.cod:=(codborrar*-1);//En regCabecera pongo el negativo del
    write(archivo,reg); ////cod de novela que voy a eliminar
    seek(archivo,(codborrar*-1));
    write(archivo,regAux);
end;
{----------------------------------------------------------}
procedure AbrirArchivo();
var
    cerrar:boolean;
    nombre:string[20];    
    archivo:archivoNov;
    opcion:integer;
begin
    cerrar:=true;
    write('Nombre del archivo a abrir: ');
    readln(nombre);
    assign(archivo,nombre);
    reset(archivo);
    while(cerrar) do begin
        writeln('--Acciones para el archivo ',nombre,'--');
        writeln('OPCION 1: Dar de alta una novela');
        writeln('OPCION 2: Modificar los datos de una novela');
        writeln('OPCION 3: Eliminar una novela');
        writeln('OPCION 4: Ir al menu anterior');
        write('Usted va a elegir la opcion: ');
        readln(opcion);
        case opcion of
            1:DarDeAlta(archivo);
            2:ModificarDatos(archivo);
            3:EliminarUnaNovela(archivo);
            4:cerrar:=false;
        end;
    end;
    close(archivo);
end;

{----------------------------------------------------------}
procedure ExportarTxt();
var
    texto:Text;
    r:novela;
    archivo:archivoNov;
    nom,nom1:string[20];
begin
    write('Archivo que quiere pasar a txt: ');
    readln(nom);
    assign(archivo,nom);
    reset(archivo); 
    write('Nombre del txt: ');
    readln(nom1);
    assign(texto,nom1);
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivo)) do begin
        read(archivo,r);
        with r do begin
          writeln(texto,' cod: ',cod,' Nombre: ',nombre);
          writeln(texto,' Genero: ',genero);
        end;
    end;
    close(texto);
    close(archivo);
end;

{----------------------------------------------------------}
var
    opcion:integer;
    cerrar:boolean;
begin
    cerrar:=true;
    while(cerrar) do begin
        writeln('----MENU-----');
        writeln('OPCION 1: Crear archivo');
        writeln('OPCION 2: Abrir archivo');
        writeln('OPCION 3: Pasar a un txt');
        writeln('OPCION 4: Cerrar programa');
        write('Usted va a elegir la opcion: ');
        readln(opcion);
        case opcion of
            1:CrearArchivo();
            2:AbrirArchivo();
            3:ExportarTxt();
            4:cerrar:=false;
        end;
    end;
end.

