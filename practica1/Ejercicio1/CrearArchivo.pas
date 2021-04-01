program CrearArchivo;
type
    archivo= file of integer;
{------------------------------------------------------------------------------------------}

procedure LeerNum (var n:integer);
begin
    write('Escriba un numero: ');
    readln(n);
end;

{------------------------------------------------------------------------------------------}
var
    n:integer;
    nombrefisico:String;
    archivoNum:archivo;
begin
    write('Ingrese nombre del archivo: ');
    read(nombrefisico);
    Assign(archivoNum,nombrefisico);
    rewrite(archivoNum);
    LeerNum(n);
    while(n<>30000) do begin
        write(archivoNum,n);
        LeerNum(n)    
    end;
    close(archivoNum);
end.
