program EjercicioNovela;
type
    registro = record
        cod:integer;
        nombre:String[20];
        genero:String[20];
        precio:real;
    end;

    archivo = file of registro;

{---------------------------------------------------------------------------------------}

procedure CrearBinario(var archivoNovela:archivo; var texto:text);
var
    nombrefisico:String[20];
    r:registro;
begin
    Assign(texto,'novelas.txt');
    reset(texto); //abro mi txt
    write('Nombre que va a tener archivo binario: ');
    readln(nombrefisico);
    Assign(archivoNovela,nombrefisico);
    Rewrite(archivoNovela);
    while (not EOF(texto)) do begin
        with r do begin
            readln(texto,cod,precio,genero);
            readln(texto,nombre);
        end;
        write(archivoNovela,r);
    end;
end;


{---------------------------------------------------------------------------------------}

procedure LeerNovela(var r:registro);
begin
    writeln('----NOVELA----');
    write('Codigo: ');
    readln(r.cod);
    if (r.cod <> -1) then begin
        write('Nombre: ');
        readln(r.nombre);
        write('Genero: ');
        readln(r.genero);
        write('Precio: ');
        readln(r.precio);
    end;
end;

{------------------------------------------------------------------------}

procedure AgregarNovela(var archivoNovelas:archivo);
var
    cantNovelas,i:integer;
    r:registro;
begin
    write('Cuantos novelas quiere agregar?: ');
    readln(cantNovelas);
    reset(ArchivoNovelas);
    seek(ArchivoNovelas,FileSize(ArchivoNovelas));
    for i:=1 to cantNovelas do begin
        leerNovela(r);
        write(ArchivoNovelas,r);
    end;
    close(archivoNovelas);
end;

{---------------------------------------------------------------------------------------}

procedure MenuModificacion(var r:registro);
    procedure cambiarNombre(var nombre:String);
    begin
        write('Nuevo nombre para la novela: ');
        readln(nombre); 
    end;
    procedure cambiarGenero(var genero:String);
    begin
        write('Nuevo genero para la novela: ');
        readln(genero);
    end;
    procedure cambiarPrecio(var precio:real);
    begin
        write('Nuevo precio para la novela: ');
        readln(precio); 
    end;
    procedure cambiarCodigo(var codigo:integer);
    begin
        write('Nuevo codigo para la novela: ');
        readln(codigo);
    end;
var
    opcion:integer;
begin
    writeln('-----MENU MODIFICACION-----');
    writeln('OPCION 1: Modificar nombre');
    writeln('OPCION 2: Modificar genero');
    writeln('OPCION 3: Modificar precio');
    writeln('OPCION 4: Modificar codigo');
    write('Usted elije la opcion: ');
    readln(opcion);
    case opcion of
        1:cambiarNombre(r.nombre);
        2:cambiarGenero(r.genero);
        3:cambiarPrecio(r.precio);
        4:cambiarCodigo(r.cod);
    end;
end;

{---------------------------------------------------------------------------------------}

procedure ModificarNovelas(var archivoNovelas:archivo);
var
    terminar:String[2];
    bool:boolean;
    codnovela,opcion:integer;
    r:registro;
    nombre,genero:String[20];
    precio:real;
begin
    terminar:='no';
    reset(ArchivoNovelas); //abro mi archivo binario
    while (terminar <> 'si') do begin
        bool:=false;
        seek(archivoNovelas,0);
        write('Codigo de novela que quiere modificar: ');
        readln(codnovela);
        while(not EOF(archivoNovelas) or (not bool)) do begin
            read(archivoNovelas,r);
            if (codnovela = r.cod) then begin
                bool:=true;
                MenuModificacion(r);
                seek(ArchivoNovelas,FilePos(archivoNovelas)-1);
                write(ArchivoNovelas,r);
            end;
        end;
        write('Desea terminar de modificar novelas? (si o no): ');
        readln(terminar);
    end;
    close(ArchivoNovelas);
end;

{---------------------------------------------------------------------------------------}

procedure DeBinarioATxt(var archivoNovelas:Archivo);
var
    r:registro;
    texto:Text;
begin
    reset(archivoNovelas); //abro mi archivo binario
    assign(texto,'celular.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoNovelas)) do begin
        read(archivoNovelas,r);
        with r do
          writeln(texto,' ',cod,' ',nombre,' ',genero,' ',precio:5:2);
    end;
    close(texto);
    close(archivoNovelas);
end;

{---------------------------------------------------------------------------------------}
var
    archivoNovelas:archivo;
    texto:Text;
begin
    CrearBinario(archivoNovelas,texto);
    AgregarNovela(archivoNovelas);
    ModificarNovelas(ArchivoNovelas);
    DeBinarioATxt(ArchivoNovelas);
end.
