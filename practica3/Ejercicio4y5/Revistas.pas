program Revistas;
type
    tTitulo=String[50];
    ArchRevistas=file of tTitulo;

{----------------------------------------------------------}

procedure CrearArchivo();
var
    archivo:archivoNov;
    tituloRevista:string[50];
begin
    assign(archivo,'archivoRevista');
    Rewrite(archivo);
    tituloRevista:=0; //lista invertida
    write(archivo,n);
    write('Titulo de la revista: ');
    readln(tituloRevista);
    while (tituloRevista <> 'ZZZ') do begin
        write(archivo,tituloRevista);
        write('Titulo de la revista: ');
        readln(tituloRevista);
    end;
    close(archivo);
end;

{----------------------------------------------------------}

procedure Leer (var archivo:ArchRevistas; dato:string);
begin
    if(not EOF(archivo)) then
        read(archivo,dato)
    else
        dato:='ZZZ';
end;
{----------------------------------------------------------}

procedure Agregar (var a:ArchRevistas; titulo:string);
var
    tit:string[50];
begin
    assign(a,'archivoRevista');
    reset(a);
    leer(a,tit);
    if (tit <> '0') then begin
        seek(a,tit);
        write(a,titulo);
    end
    else
        writeln('No pueden agregarse mas titulos');
end;

{----------------------------------------------------------}

procedure Eliminar(var a:ArchRevistas; titulo:string);
var
    tit:string[50];
begin
    assign(a,'archivoRevista');
    reset(a);
    while (not EOF(a)) do begin
        
    end;
end;

{----------------------------------------------------------}

procedure ImprimirContenido(var a:ArchRevistas);
begin
end;

{----------------------------------------------------------}
var
    a:ArchRevistas;
    titulo:string[50];
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
        writeln('OPCION 5: Salir del programa');
        write('Opcion a elegir: ');
        readln(opcion);
        case opcion of 
            1:CrearArchivo();
            2:begin
              write('Titulo a agregar: ');
              readln(titulo);
              Agregar(a,titulo);
              end;
            3:begin
              write('Titulo a eliminar: ');
              readln(titulo);
              Eliminar(a,titulo);
              end;
            4:ImprimirContenido(a:ArchRevistas);
            5:corte:=false;
        end;
    end;
end.