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

procedure DarDeAlta(archivo:archivoNov);
var
    reg:novela;
    codnovela:integer;
begin
    write('Codigo de la novela que quiere dar de alta: ');
    readln(codnovela);
    
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

