program ImprimirArchivoNumeros;
type
    archivo=file of integer;
{------------------------------------------------------------------------------------------}
var
    archivonum:archivo;
    nombrefisico:String[20];
    cantmenores,contNum,totalNum,num:integer;
begin
    cantmenores:=0;
    contNum:=0;
    totalNum:=0;
    write('Nombre del archivo a procesar: ');
    readln(nombrefisico);
    assign(archivonum,nombrefisico); //asigno espacio en disco
    reset(archivonum); //lo habilito para lectura
    while (not EOF(archivonum)) do begin //mientras mi archivo no termine
        contNum:=contNum+1; 
        read(archivonum,num); //num:=numero de mi archivo
        if (num < 1500) then
            cantmenores:=cantmenores+1;
        write(num,',');
        totalNum:=totalNum+num;
    end;
    close(archivonum);
    writeln();
    writeln('Hay ',cantmenores,' numeros menores a 1500');
    if (contNum <>0) then
        WriteLn('El promedio de todos los numeros es: ',(totalNum/contNum));
end.