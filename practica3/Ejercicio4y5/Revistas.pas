program Revistas;
const
    valoralto='ZZZZ';
type
    tTitulo=String[50];
    ArchRevistas=file of tTitulo;

{----------------------------------------------------------}

procedure CrearArchivo();
var
    archivo:archRevistas;
    tituloRevista:string[50];
begin
    assign(archivo,'archivoRevista');
    Rewrite(archivo);
    write(archivo,'0'); //lista invertida - cabecera
    write('Titulo de la revista: ');
    readln(tituloRevista);
    while (tituloRevista <> valoralto) do begin
        write(archivo,tituloRevista);
        write('Titulo de la revista: ');
        readln(tituloRevista);
    end;
    close(archivo);
end;

{----------------------------------------------------------}

procedure Leer (var archivo:ArchRevistas; var dato:tTitulo);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato:=valoralto;
end;
{----------------------------------------------------------}
//String a integer con Val()
//integer a String con Str()

procedure Agregar (var archivo:ArchRevistas; titulo:tTitulo);
var
    NTxt,aux:tTitulo;
    N:integer;
begin
    assign(archivo,'archivoRevista');
    reset(archivo);
    leer(archivo,Ntxt); //leo Cabecera
    val(Ntxt,N); //convierto Ntxt a un integer
    if (N <> 0) then begin
        seek(archivo,N); //posiciono en la pos que marcaba la cabecera
        read(archivo,aux); //aux=lo que estaba en la pos N

        seek(archivo,filepos(archivo)-1);
        write(archivo,titulo); //agrego mi titulo de revista

        seek(archivo,0); //posiciono cabecera
        write(archivo,aux);//escribo en cabecera=aux
    end
    else begin
        seek(archivo,FileSize(archivo)); 
        write(archivo,titulo);
        writeln('Su nueva novela se ingreso atras de todo!');
    end;
end;

{----------------------------------------------------------}

procedure Eliminar(var archivo:ArchRevistas; titulo:string);
var
    tit,cabecera,posString:tTitulo;
    pos:integer;
begin
    assign(archivo,'archivoRevista');
    reset(archivo);
    Leer(archivo,cabecera); //guardo mi cabecera
    while ((tit<>valoralto) and (tit<>titulo)) do begin //valor inicial de tit:=''
        Leer(archivo,tit);
    end;
    if (tit = titulo) then begin
        pos:=(filepos(archivo)-1); //pos:=posicion de mi archivo a eliminar
        seek(archivo,pos); //posiciono en dato a eliminar
        write(archivo,cabecera); //escribo ahi lo que estaba en la Cabecera
        seek(archivo,0); //voy a la cabecera
        Str(pos,posString); //convierto a un string la posicion de mi archivo eliminado
        write(archivo,posString);//cabecera=dato que elimine 
    end
    else
        writeln('Ese titulo no se encontro');
    close(archivo);
end;

{----------------------------------------------------------}
//String a integer con Val()
//integer a String con Str()
procedure ImprimirContenido(var archivo:ArchRevistas);
var
    tit:tTitulo;
    titInt,codError:integer;
begin
    assign(archivo,'archivoRevista');
    reset(archivo);
    Leer(archivo,tit);
    writeln('--Titulos no borrados--');
    while(tit <> valoralto) do begin
        Val(tit,titInt,codError);
        if(codError<>0) then begin
            writeln(tit);
        end;
        Leer(archivo,tit);
    end;
end;

{----------------------------------------------------------}

procedure ExportarTxt();
var
    texto:Text;
    titulo:tTitulo;
    archivo:ArchRevistas;
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
        read(archivo,titulo);
        writeln(texto,' ',titulo);
    end;
    close(texto);
    close(archivo);
end;


{----------------------------------------------------------}

var
    archivo:ArchRevistas;
    titulo:tTitulo;
    opcion:integer;
    corte:boolean;
begin
    corte:=true;
    while(corte) do begin
        writeln('---MENU----');
        writeln('OPCION 1: Crear archivo.');
        writeln('OPCION 2: Agregar un titulo');
        writeln('OPCION 3: Eliminar un titulo');
        writeln('OPCION 4: Imprimir archivo');
        writeln('OPCION 5: Pasar a un txt');
        writeln('OPCION 6: Salir del programa');
        write('Opcion a elegir: ');
        readln(opcion);
        case opcion of 
            1:CrearArchivo();
            2:begin
              write('Titulo a agregar: ');
              readln(titulo);
              Agregar(archivo,titulo);
              end;
            3:begin
              write('Titulo a eliminar: ');
              readln(titulo);
              Eliminar(archivo,titulo);
              end;
            4:ImprimirContenido(archivo);
            5:ExportarTxt();
            6:corte:=false;
        end;
    end;
end.