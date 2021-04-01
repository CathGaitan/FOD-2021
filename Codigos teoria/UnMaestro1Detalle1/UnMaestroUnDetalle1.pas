program UnMaestroUnDetalle1; //Cada elemento del maestro que se modifica es alterado por uno
const                        //y solo un elemento del archivo detalle.
    valoralto='9999';
type
    producto = record
        cod:string[4];
        descripcion:string[30];
        pu:real;
        stock:integer;
    end;
    
    venta_prod = record
        cod:string[4];
        cant_vendida:integer;
    end;
    
    detalle = file of venta_prod;
    maestro = file of producto;

var 
    regM:producto; //registro MAESTRO 
    regD:venta_prod; //registro DETALLE 
    mae1:maestro;
    det1:detalle;
    total:integer;
    auxcod:string[4];

{----------------------------------------------------------------------------}

begin
    assign(mae1,'maestro'); // asigno a mis variables un
    assign(det1,'detalle'); // lugar fisico donde guardarse
    reset(mae1); // los abro para poder
    reset(det1); // hacer lectura
    while (not EOF(det1)) do begin //mientras el archivo detalle no termine
        read(mae1,regM); //regM=dato apunta archivo MAESTRO
        read(det1,regD);//regD=dato apunta archivo DETALLE
        while (regM.cod <> regD.cod) do //hago que coincidan el cod maestro con el cod detalle
            read(mae1,regM); //regM=dato apunta archivo MAESTRO
        regM.stock:=regM.stock-regD.cant_vendida; //actualiza stock en el registro Maestro.
        seek(mae1,filepos(mae1)-1); // reubico el puntero (porque lo desacomodo el read anterior)
        write(mae1,regM); //actualizo mi archivo maestro 
    end;
    close(mae1); // cierro mis
    close(det1); // archivos
end.
