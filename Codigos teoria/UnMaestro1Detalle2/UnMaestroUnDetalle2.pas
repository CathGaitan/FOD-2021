program UnMaestroUnDetalle2; //Cada elemento del archivo maestro puede no ser modificado o ser
const                        //modificado por uno o mas elementos del detalle 
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

procedure Leer (var archivoDeta:detalle; var datoD:venta_prod);
begin
    if (not EOF(archivoDeta)) then
        read(archivoDeta,datoD) //en datoD=el dato apuntado en archivoDeta
    else
        datoD.cod:=valoralto; //para cortar el while 
end;

{----------------------------------------------------------------------------}

begin
    assign(mae1,'maestro'); // asigno a mis variables un
    assign(det1,'detalle'); // lugar fisico donde guardarse
    reset(mae1); // los abro para poder
    reset(det1); // hacer lectura
    read(mae1,regM);
    leer(det1,regD);
    while (regD.cod <> valoralto) do begin
        auxcod:=regD.cod; //guardo mi cod detalle
        total:=0;
        while (auxcod = regD.cod) do begin //salgo si: 1)cambio el regDetalle 2)Se llego al final del archivo
            total:=total+regD.cant_vendida;
            leer(det1,regD);
        end;
        while (regM.cod <> auxcod) do
            read(mae1,regM); //busco ese codigo en el maestro
        regM.cant:=regM.cant-total;
        seek(mae1,FilePos(mae1)-1);
        write(mae1,regM);
        if (not EOF(mae1)) then //avanzo en el maestro
            read(mae1,regM);
    end;
    close(mae1);
    close(det1);
end.
    
